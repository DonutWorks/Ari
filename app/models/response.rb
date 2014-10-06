class Response < ActiveRecord::Base
  STATUSES = %w(yes maybe no)

  belongs_to :notice
  belongs_to :user

  validates :status, presence: { message: "회답을 선택해주십시오." },
   inclusion: { in: STATUSES, message: "올바르지 않은 회답입니다." }
end