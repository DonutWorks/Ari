class ResponseObserver < ActiveRecord::Observer
  def after_update(response)
    comment = "[" + response.notice.title + "] 공지의 참가상태가 " + sms_setting_status(response) + "로 변경 되었습니다."

    Admin::Messages::SendMessageService.new.execute(comment, response.notice.id, response.user.id)
  end

  def after_create(response)
    comment = "[" + response.notice.title + "] 공지의 참가상태가 " + sms_setting_status(response) + "로 신청 되었습니다."

    Admin::Messages::SendMessageService.new.execute(comment, response.notice.id, response.user.id)
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
        status = "'찬성'으"
      when "maybe"
        status = "'보류'"
      when "no"
        status = "'반대'"
      end

      status
    end
end