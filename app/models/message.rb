class Message < ActiveRecord::Base
  has_many :message_histories
  has_many :user, through: :message_histories

  validates_presence_of :text, :message => "전송할 SMS 내용은 반드시 있어야 합니다."
end