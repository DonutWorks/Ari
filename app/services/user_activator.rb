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

  def send_ticket_mail(user, activation_url)
    mailgun = Mailgun()
    parameters = {
      :from => "ari@donutworks.com",
      :to => user.email,
      :subject => "서울대 햇빛봉사단의 계정 활성화를 위한 메일입니다.",
      :html => "<div><h2>서울대 햇빛봉사단 계정을 활성화 시키려면 아래의 링크를 클릭 해주세요.</h2></div><div>#{activation_url}</div>"
    }
    mailgun.messages.send_email(parameters)
  end

  def send_ticket_sms(user, activation_url)
    shortener = URLShortener.new
    url = shortener.shorten_url(activation_url)

    sms_content = "[인증 url] => " + url
    sms_sender = SmsSender.new
    sms_sender.send_message(sms_content, user.id)
  end
end