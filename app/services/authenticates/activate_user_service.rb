module Authenticates
  class ActivateUserService
    def execute(signed_in_user, code)
      ticket = ActivationTicket.find_by(code: code)
      return failure if ticket.nil? or ticket.expired

      user = ticket.user
      return failure if user != signed_in_user

      user.transaction do
        user.update_attributes!(activated: true)
        ticket.update_attributes!(expired: true)
      end

      return success
    end

  private
    def success
      { status: :success }
    end

    def failure
      { status: :failure }
    end
  end
end