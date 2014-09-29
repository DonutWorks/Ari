class UserActivator
  def issue_ticket(user, provider_token)
    user.transaction do
      activation = AccountActivation.find_or_initialize_by(
        provider_token_id: provider_token.id
      )
      activation.update_attributes!(user: user)

      ticket = ActivationTicket.where(account_activation: activation, expired: false).first
      ticket.update_attributes!(expired: true) if ticket
      ticket = ActivationTicket.create!(account_activation: activation)

      return ticket
    end
  rescue => e
    return nil
  end

  def activate(code, provider_token)
    ticket = ActivationTicket.find_by_code(code)
    return false if ticket.nil? or ticket.expired

    activation = ticket.account_activation
    registered_token = ProviderToken.find_by_id(activation.provider_token_id)
    return false if registered_token != provider_token

    activation.transaction do
      activation.activate!
      ticket.update_attributes!(expired: true)
      activation.save!
    end

    return true

  rescue => e
    return false
  end

  # need bang methods
end