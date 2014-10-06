require "rails_helper"

RSpec.describe User, :type => :model do
  it "should remove dashes in phone_number before save" do
    user = FactoryGirl.build(:user)
    user.phone_number = "010-1234-1234"
    user.save!

    expect(user.phone_number).to eq("01012341234")

    user.phone_number = "010-123-1234"
    user.save!

    expect(user.phone_number).to eq("0101231234")
  end

  describe "#activated?" do
    context "user not attempted to sign in" do
      it "should return false for user not attempted to sign in" do
        user = FactoryGirl.create(:user)
        expect(user.activated?).to eq(false)
      end
    end

    context "user attempted to sign in" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @token = FactoryGirl.create(:provider_token)

        @activator = UserActivator.new
        @ticket = @activator.issue_ticket(@user, @token)
      end

      it "should return false for user not activated" do
        expect(@user.activated?).to eq(false)
      end

      it "should return true for activated user" do
        @activator.activate(@ticket.code, @token)
        @user.reload
        expect(@user.activated?).to eq(true)
      end
    end
  end
end