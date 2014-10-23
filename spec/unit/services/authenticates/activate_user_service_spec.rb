require "rails_helper"

RSpec.describe Authenticates::ActivateUserService do
  before(:each) do
    @club = FactoryGirl.create(:complete_club)
    @user = @club.users.first
  end

  context "when try to activate a user by using invitation code" do
    before(:each) do
      out = Authenticates::CreateInvitationService.new(@club).execute(nil, @user)
      @code = out[:code]
    end

    context "when using valid code" do
      before(:each) do
        out = Authenticates::ActivateUserService.new(@club).execute(@user, @code)
        @status = out[:status]
        @user.reload
      end

      it "should be success" do
        expect(@status).to eq(:success)
        expect(@user.activated?).to eq(true)
      end

      it "should expire invitation" do
        invitation = Invitation.find_by(code: @code)
        expect(invitation.expired).to eq(true)
      end
    end

    context "when using invalid code" do
      it "should not activate a user" do
        out = Authenticates::ActivateUserService.new(@club).execute(@user, @code + "invalid")
        @user.reload

        expect(out[:status]).to eq(:failure)
        expect(@user.activated?).to eq(false)
      end
    end

    context "when using expired code" do
      it "should not activate a user" do
        # for expiring old invitation
        Authenticates::CreateInvitationService.new(@club).execute(nil, @user)
        out = Authenticates::ActivateUserService.new(@club).execute(@user, @code)
        @user.reload

        expect(out[:status]).to eq(:failure)
        expect(@user.activated?).to eq(false)
      end
    end
  end
end