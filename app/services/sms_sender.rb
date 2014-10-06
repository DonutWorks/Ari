class SmsSender
  class SMSSenderError < RuntimeError
  end

  def send_message(content, user_ids)
    message = Message.new
    message.content = content

    if message.save
      user_ids.each do |user_id|

        user = User.find(user_id)

        sms_info = {
          from: "114", #보내는 사람
          to: user.phone_number, #받는 사람
          user: "donutworks",
          password: "donutwork1!",
          text: "[서울대 햇빛봉사단]" + message.content #SMS내용
        }

        sms_sender = SendSMS.new

        begin
          sms_sender.send_sms(sms_info)
        rescue SendSMS::SendSMSError => e
          raise SMSSenderError, e.message
        else
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