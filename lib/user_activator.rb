class UserActivator
  def issue_ticket(user, auth_hash)
    user.transaction do
      activation = AccountActivation.where(uid: auth_hash['uid'], provider: auth_hash['provider']).first_or_create(
        user: user
      )
      ticket = ActivationTicket.where(account_activation: activation).first_or_create()
      send_ticket_mail(ticket)
      return true
    end
  rescue
    return false
  end

  def activate(code)
    ticket = ActivationTicket.find_by_code(code)
    return false if ticket.nil?

    activation = ticket.account_activation
    activation.activate!
    return activation.save
  end

  # need bang methods

private
  def send_ticket_mail(ticket)

  end
end