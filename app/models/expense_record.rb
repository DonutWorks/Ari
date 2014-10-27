class ExpenseRecord < ActiveRecord::Base
  belongs_to :account

  validates :record_date, :uniqueness => {:scope => [:deposit, :withdraw, :content]}
end