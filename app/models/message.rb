class Message < ActiveRecord::Base
  has_many :message_histories
  has_many :users, through: :message_histories
  belongs_to :notice

  scope :created_at_sorted_desc, -> { order(created_at: :desc) }

  validates_presence_of :content, message: "전송할 SMS 내용은 반드시 있어야 합니다."

  def show
  end
end