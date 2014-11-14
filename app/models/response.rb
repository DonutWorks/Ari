class Response < ActiveRecord::Base
  STATUSES = %w(yes maybe no go wait)

  belongs_to :notice
  belongs_to :expense_record
  belongs_to :user
  belongs_to :club


  scope :responsed_to_go, -> (notice) { notice.responses.where(status: "go") }
  scope :time, -> (notice) { find_by_notice_id(notice.id).decorate.responsed_at }

  validates :status, presence: { message: "회답을 선택해주십시오." },
   inclusion: { in: STATUSES, message: "올바르지 않은 회답입니다." }
  validates :user, uniqueness: { scope: :notice_id, message: "는 하나의 응답만을 할 수 있습니다." }
  validates :user, presence: true
  validates :notice, presence: true

  def self.find_remaining_responses
    cases = []

    Notice.where(notice_type: 'to').each do |notice|
      notice.responses.each do |response|
        cases << {
          id: response.id,
          activity: notice.activity,
          notice: notice,
          response: response,
          user: response.user} if response.dues == 0
      end
    end

    cases
  end
end