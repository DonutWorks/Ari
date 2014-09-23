class UserActivator
  def issue_ticket(user, auth_hash)
    user.transaction do
      activation = AccountActivation.where(uid: auth_hash['uid'], provider: auth_hash['provider']).first_or_create(
        user: user
      )
      ticket = ActivationTicket.where(account_activation: activation).first_or_create()
      return ticket
    end
  rescue => e
    return nil
  end

  def activate(code)
    ticket = ActivationTicket.find_by_code(code)
    return false if ticket.nil?

    activation = ticket.account_activation
    activation.activate!

    activation.transaction do
      ticket.destroy!
      activation.save!
    end

    return true

  rescue => e
    return false
  end

  # need bang methods
end