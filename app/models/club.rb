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
  has_many :activities
  has_many :bank_accounts

  def representive
    AdminUser.find_by(club: self)
  end

  def last_signed_in_at
    representive.last_sign_in_at if representive
  end
end
