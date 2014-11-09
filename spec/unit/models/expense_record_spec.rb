require "rails_helper"

RSpec.describe ExpenseRecord, :type => :model do
  describe "check validations" do
    it "should check validates uniqueness of record_date" do
      FactoryGirl.create(:expense_record)

      er = ExpenseRecord.new(record_date: "2000-01-01")
      er.valid?
      expect(er.errors.messages.keys).to be_empty

      er.attributes = {
        deposit: 20000,
        withdraw: 0,
        content: "hi"
      }
      er.valid?
      expect(er.errors.messages.keys).to be_empty

      er.content = "John"
      er.valid?
      expect(er.errors.messages.keys).to be_include(:record_date)
    end
  end

  describe "#check_dues" do
    before(:each) do
      @club = FactoryGirl.create(:complete_club)
      @user = @club.users.first
    end

    it "should return nil when notice is not found" do
      er = FactoryGirl.create(:expense_record)
      expect(er.check_dues).to eq(nil)
    end

    it "should return nil when user is not found in content" do
      notice = FactoryGirl.create(:to_notice, activity: @club.activities.first)
      notice.responses.create({
        user: FactoryGirl.create(:user),
        status: "go"})

      er = FactoryGirl.build(:expense_record, content: "hi")
      expect(er.check_dues).to eq(nil)
    end

    it "should return normal data successfully" do
      notice = FactoryGirl.create(:to_notice, activity: @club.activities.first)
      user = FactoryGirl.create(:user, username: "John", club: @club)
      notice.responses.create({
        user: user,
        status: "go"})

      er = FactoryGirl.build(:expense_record, bank_account: @club.bank_accounts.first)

      expect(er.check_dues).to eq({
        user: user, notice: notice, dues: 20000})
    end
  end
end