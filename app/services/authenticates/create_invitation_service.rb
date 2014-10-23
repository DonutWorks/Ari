module Authenticates
  class CreateInvitationService < BaseService
    def execute(signed_in_user, user_params)
      return failure unless user_params

      normalizer = FormNormalizers::PhoneNumberNormalizer.new

      begin
        user_phone_number = normalizer.normalize(user_params.phone_number)
      rescue FormNormalizers::NormalizeError => e
        return invalid_phone_number
      end

      user = current_club.users.find_by(phone_number: user_phone_number)
      return invalid_phone_number if user.nil?

      # move provider info to new user
      if user != signed_in_user and !user.activated?
        begin
          user.transaction do
            user.update_attributes!({
              provider: user_params.provider,
              uid: user_params.uid,
              extra_info: user_params.extra_info
            })
            signed_in_user.update_attributes!({
              provider: nil,
              uid: nil,
              extra_info: nil
            }) unless signed_in_user.nil?
          end
        rescue ActiveRecord::RecordInvalid => e
          return failure
        end
      end

      # send a ticket
      begin
        current_club.invitations.where(user: user).update_all(expired: true)
        ticket = current_club.invitations.create!(user: user)
      rescue ActiveRecord::RecordInvalid => e
        return failure
      end

      return success({ code: ticket.code })
    end

    def send_invitation_sms(user, invitation_url)
      shortener = URLShortener.new
      url = shortener.shorten_url(invitation_url)

      normalizer = FormNormalizers::PhoneNumberNormalizer.new

      begin
        user_phone_number = normalizer.normalize(user.phone_number)
      rescue FormNormalizers::NormalizeError => e
        return false
      end

      sms_info = {
        from: current_club.representive.phone_number,
        to: user_phone_number,
        text: "[인증 url] => " + url
      }

      sms_sender = SMSSender.new
      begin
        sms_sender.send_sms(sms_info)
      rescue SMSSender::SMSSenderError => e
        return false
      end
      return true
    end

  private
    def invalid_phone_number
      failure({ status: :invalid_phone_number })
    end
  end
end