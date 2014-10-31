module Authenticates
  class ActivateUserService < BaseService
    def execute(signed_in_user, code)
      ticket = Invitation.find_by(code: code)
      return failure if ticket.nil?
      return failure({ status: :expired_ticket }) if ticket.expired

      user = ticket.user
      return failure if user != signed_in_user

      user.transaction do
        user.update_attributes!(activated: true)
        ticket.update_attributes!(expired: true)
      end

      return success
    end
  end
end