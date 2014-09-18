class AccountActivation < ActiveRecord::Base
  belongs_to :user
  has_one :activation_ticket
end
