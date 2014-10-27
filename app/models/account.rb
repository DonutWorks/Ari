class Account < ActiveRecord::Base
  has_many :expense_records

  validates :account_number, presence: true, uniqueness: true
end