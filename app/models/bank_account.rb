class BankAccount < ActiveRecord::Base
  belongs_to :club
  has_many :expense_records

  validates :account_number, presence: true, uniqueness: true
end