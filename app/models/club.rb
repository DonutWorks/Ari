class Club < ActiveRecord::Base
  has_many :admins
  has_many :invitations
  has_many :messages
  has_many :notices
  has_many :responses
  has_many :users
end
