class Response < ActiveRecord::Base
  STATUSES = %w(yes maybe no go wait)

  belongs_to :notice
  belongs_to :user  
  belongs_to :expense_record

  scope :responsed_to_go, -> (notice) { notice.responses.where(status: "go") }
  scope :time, -> (notice) { find_by_notice_id(notice.id).decorate.responsed_at }

  validates :status, presence: { message: "회답을 선택해주십시오." },
   inclusion: { in: STATUSES, message: "올바르지 않은 회답입니다." }

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