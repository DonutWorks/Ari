class SmsSender
  class SMSSenderError < RuntimeError
  end

  def send_message(content, notice_id, user_ids)
    message = Message.new
    message.content = content
    message.notice_id = notice_id

    if message.save


      users = User.where(id: user_ids)

      sms_info = {
        from: "114", #보내는 사람
        to: users.pluck(:phone_number).join(","), #받는 사람
        text: "[서울대 햇빛봉사단]" + message.content #SMS내용
      }

      sms_sender = SendSMS2.new

      begin
        sms_sender.send_sms(sms_info)
      rescue SendSMS2::SendSMSError => e
        raise SMSSenderError, e.message
      else
        users.each do |user|
          message_histories = MessageHistory.new
          message_histories.user_id = user.id
          message_histories.message_id = message.id

          message_histories.save
        end
      end


      return message
    else
      raise SMSSenderError, "현재 message를 보낼 수 없습니다. 다음에 다시 시도해주세요."
    end

  end

end