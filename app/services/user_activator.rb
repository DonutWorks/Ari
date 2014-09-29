class UserActivator
  def issue_ticket(user, provider_token)
    user.transaction do
      activation = AccountActivation.find_or_initialize_by(
        provider_token_id: provider_token.id
      )
      activation.update_attributes!(user: user)

      ticket = ActivationTicket.where(account_activation: activation).first_or_create
      return ticket
    end
  rescue => e
    return nil
  end

  def activate(code, provider_token)
    ticket = ActivationTicket.find_by_code(code)
    return false if ticket.nil?

    activation = ticket.account_activation
    registered_token = ProviderToken.find_by_id(activation.provider_token_id)
    return false if registered_token != provider_token

    activation.transaction do
      activation.activate!
      ticket.destroy!
      activation.save!
    end

    return true

  rescue => e
    raise e.inspect
    return false
  end

  # need bang methods
end