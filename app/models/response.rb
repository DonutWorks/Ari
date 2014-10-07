class Response < ActiveRecord::Base
  STATUSES = %w(yes maybe no)

  belongs_to :notice
  belongs_to :user

  scope :time, -> (notice) { find_by_notice_id(notice.id).created_at.localtime.strftime("%Y-%m-%d %T") }

  validates :status, presence: { message: "회답을 선택해주십시오." },
   inclusion: { in: STATUSES, message: "올바르지 않은 회답입니다." }
end