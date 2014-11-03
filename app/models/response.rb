class Response < ActiveRecord::Base
  STATUSES = %w(yes maybe no go wait)

  belongs_to :notice
  belongs_to :user

  validates :status, presence: { message: "회답을 선택해주십시오." },
   inclusion: { in: STATUSES, message: "올바르지 않은 회답입니다." }

  scope :responsed_to_go, -> (notice) { notice.responses.where(status: "go") }

  def self.time (notice)
    response = find_by_notice_id(notice.id)

    if response
      return response.created_at.localtime.strftime("%Y-%m-%d %T")
    else
      return ""
    end
  end

  def responsed_at
    created_at.localtime.strftime("%Y-%m-%d %T")
  end
end