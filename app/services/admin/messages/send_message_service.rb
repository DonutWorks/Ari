module Admin::Messages
  class SendMessageService < Admin::BaseService
    def execute(content, notice_id, user_ids)
      # notice_id can be nil
      # return failure unless Notice.exists?(notice_id)

      message = Message.new(content: content, notice_id: notice_id)
      users = User.where(id: user_ids)
      users.each do |user|
        message.message_histories.build(user_id: user.id)
      end

      sms_sender = SMSSender.new
      sms_info = {
        from: "01044127987",
        to: users.pluck(:phone_number).join(","),
        text: message.content
      }

      message.transaction do
        message.save!
        sms_sender.send_sms(sms_info)
      end

      return success({ message: message })

    rescue SMSSender::SMSSenderError, ActiveRecord::RecordInvalid => e
      return failure
    end
  end
end