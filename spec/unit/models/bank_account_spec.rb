require "rails_helper"

RSpec.describe BankAccount, :type => :model do
  describe "check validations" do
    it "should check validates presence of account_number" do
      ba = BankAccount.new
      ba.valid?

      expect(ba.errors.messages.keys).to be_include(:account_number)
    end

    it "should check validates uniqueness of account_number" do 
      BankAccount.create(account_number: "1103335555555")
      
      new_ba = BankAccount.new(account_number: "1103335555555")
      new_ba.valid?

      expect(new_ba.errors.messages.keys).to be_include(:account_number)
    end
  end
end