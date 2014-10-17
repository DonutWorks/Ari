module Authenticates
  class CreateInvitationService < BaseService
    def execute(signed_in_user, user_params)
      return failure unless user_params

      user = User.find_by(email: user_params.email)
      return failure({ status: :invalid_email }) if user.nil?

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
        Invitation.where(user: user).update_all(expired: true)
        ticket = Invitation.create!(user: user)
      rescue ActiveRecord::RecordInvalid => e
        return failure
      end

      return success({ code: ticket.code })
    end

    def send_invitation_mail(email, invitation_url)
      mailgun = Mailgun()
      parameters = {
        :from => "ari@donutworks.com",
        :to => email,
        :subject => "서울대 햇빛봉사단의 계정 활성화를 위한 메일입니다.",
        :html => "<div><h2>서울대 햇빛봉사단 계정을 활성화 시키려면 아래의 링크를 클릭 해주세요.</h2></div><div>#{invitation_url}</div>"
      }
      mailgun.messages.send_email(parameters)
    end
  end
end