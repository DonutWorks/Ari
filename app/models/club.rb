class Club < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name

  has_many :admins
  has_many :invitations
  has_many :messages
  has_many :notices
  has_many :responses
  has_many :users

  def representive
    Admin.find_by(club: self)
  end
end
