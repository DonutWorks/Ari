class Response < ActiveRecord::Base
  STATUSES = %w(yes maybe no go wait)

  belongs_to :notice
  belongs_to :user

  scope :time, -> (notice) { find_by_notice_id(notice.id).created_at.localtime.strftime("%Y-%m-%d %T") }
  scope :responsed_to_go, -> (notice) { notice.responses.where(status: "go") }

  after_save :send_sms_auto

  def send_sms_auto 

    case self.status
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
      
    comment = "[" + self.notice.title + "] 공지의 참가상태가 " + status + "로 변경 되었습니다."

    sms_sender = SmsSender.new
    message = sms_sender.send_message(comment, self.notice, self.user)
  end

  def responsed_at
    created_at.localtime.strftime("%Y-%m-%d %T")
  end
  validates :status, presence: { message: "회답을 선택해주십시오." },
   inclusion: { in: STATUSES, message: "올바르지 않은 회답입니다." }
end