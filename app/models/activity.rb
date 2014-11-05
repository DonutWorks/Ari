class Activity < ActiveRecord::Base
  validates :title, presence: { message: "활 제목을 입력해주십시오." }
  has_many :notices, :dependent => :destroy

  scope :created_at_desc, -> { order(created_at: :desc) }
end
