class ResponseObserver < ActiveRecord::Observer
  def after_update(response)
    comment = "[" + response.notice.title + "] 공지의 참가상태가 " + sms_setting_status(response) + "로 변경 되었습니다."

    sms_sender = SmsSender.new
    message = sms_sender.send_message(comment, response.notice, response.user)
  end

  def after_create(response)
    comment = "[" + response.notice.title + "] 공지의 참가상태가 " + sms_setting_status(response) + "로 신청 되었습니다."

    sms_sender = SmsSender.new
    message = sms_sender.send_message(comment, response.notice, response.user)
  end

  private
    def sms_setting_status(response)
      case response.status
      when "go"
        status = "'참가'"
      when "wait"
        status = "'대기'"
      when "not"
        status = "'불참'으"
      when "yes"
        status = "'참가'"
      when "maybe"
        status = "'불확실'"
      when "no"
        status = "'불참'으"
      end

      status
    end
end