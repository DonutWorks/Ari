class AccountActivation < ActiveRecord::Base
	# Virtual attribute
	attr_accessor :email

  belongs_to :user
  has_one :activation_ticket, dependent: :destroy
  has_one :provider_token

  def activate!
    self.activated = true
  end

  def deactivate!
    self.activated = false
  end
end
