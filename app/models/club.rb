class Club < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :admin_users
  has_many :invitations
  has_many :messages
  has_many :notices
  has_many :responses
  has_many :users
  has_many :checklists
  has_many :tags

  def representive
    AdminUser.find_by(club: self)
  end
end
