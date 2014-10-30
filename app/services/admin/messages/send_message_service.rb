module Admin::Messages
  class SendMessageService < Admin::BaseService
    def execute(content, notice_id, user_ids)
      # notice_id can be nil
      # return failure unless Notice.exists?(notice_id)

      message = current_club.messages.new(content: content, notice_id: notice_id)
      users = current_club.users.where(id: user_ids)
      users.each do |user|
        message.message_histories.build(user_id: user.id)
      end

      sms_sender = SMSSender.new
      sms_info = {
        from: current_club.representive.phone_number,
        to: users.pluck(:phone_number).join(","),
        text: message.content
      }

      begin
        message.transaction do
          message.save!
          sms_sender.send_sms(sms_info)
        end
      rescue SMSSender::SMSSenderError, ActiveRecord::RecordInvalid => e
        return failure
      end

      return success({ message: message })
    end
  end
end