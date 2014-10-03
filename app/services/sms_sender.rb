class SmsSender
  def send(content, user_ids)
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
        sms_sender.send_sms(sms_info)

        message_histories = MessageHistory.new
        message_histories.user_id = user.id
        message_histories.message_id = message.id

        message_histories.save
      end

      return message
    else
      return false
    end
  rescue => e
    return false
  end

end