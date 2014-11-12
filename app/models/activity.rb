class Activity < ActiveRecord::Base
  belongs_to :club
  has_many :notices, :dependent => :destroy

  validates :title, presence: { message: "활동 제목을 입력해주십시오." }
  validates :club_id, presence: true

  scope :created_at_desc, -> { order(created_at: :desc) }

  def calculate_dues_sum
    dues_sum = []

    notices.where(notice_type: 'to').each do |notice|
      sum = 0
      go = 0
      wait = 0

      notice.responses.where(dues: 1).each do |response|
        case response.user.member_type
        when "예비단원"
          notice.associate_dues ? sum += notice.associate_dues : sum += 0
        else
          notice.regular_dues ? sum += notice.regular_dues : sum += 0
        end

        case response.status
        when "go"
          go += 1
        when "wait"
          wait += 1
        end
      end

      dues_sum << {notice: notice, go: go, wait: wait, sum: sum}
    end

    return dues_sum
  end
end
