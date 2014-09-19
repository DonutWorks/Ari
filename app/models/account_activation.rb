class AccountActivation < ActiveRecord::Base
  belongs_to :user
  has_one :activation_ticket

  def activate!
    self.activated = true
  end

  def deactivate!
    self.activated = false
  end
end
