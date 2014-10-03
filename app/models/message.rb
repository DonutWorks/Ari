class Message < ActiveRecord::Base
  has_many :message_histories
  has_many :users, through: :message_histories

  validates_presence_of :content, message: "전송할 SMS 내용은 반드시 있어야 합니다."

  def show
  end
end