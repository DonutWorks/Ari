class Message < ActiveRecord::Base
  has_and_belongs_to_many :user

  validates_presence_of :text, :message => "전송할 SMS 내용은 반드시 있어야 합니다."
end