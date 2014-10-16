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

  describe "#responsed_to?" do
    it "should return whether users responsed to notice" do
      user = FactoryGirl.create(:user)
      notice = FactoryGirl.create(:notice)

      expect(user.responsed_to?(notice)).to eq(false)

      response = Response.create!(user: user, notice: notice, status: "yes")
      expect(user.responsed_to?(notice)).to eq(true)
    end
  end



  describe "#response_status" do
    context "user didn't response to notice" do
      it "should return satus, users responsed to notice" do
        user = FactoryGirl.create(:user)
        notice = FactoryGirl.create(:notice)

        expect(user.response_status(notice)).to eq("not")

      end
    end
    context "user responsed 'go' to notice" do
      it "should return satus, users responsed to notice" do
        user = FactoryGirl.create(:user)
        notice = FactoryGirl.create(:notice)
        response = Response.create!(user: user, notice: notice, status: "go")
        expect(user.response_status(notice)).to eq("go")

      end
    end
    context "user responsed 'go' to notice but he/she had to be 'wait'" do
      it "should return satus, users responsed to notice" do
        user = FactoryGirl.create(:user)
        notice = FactoryGirl.create(:notice)
        response = Response.create!(user: user, notice: notice, status: "wait")
        expect(user.response_status(notice)).to eq("wait")

      end
    end
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