class Activity < ActiveRecord::Base
  belongs_to :club
  has_many :notices, :dependent => :destroy

  validates :title, presence: { message: "활동 제목을 입력해주십시오." }

  scope :created_at_desc, -> { order(created_at: :desc) }
end
