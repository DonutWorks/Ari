require "rails_helper"

RSpec.describe Authenticates::CreateInvitationService do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  it "should create invitation for a user" do
    out = Authenticates::CreateInvitationService.new.execute(nil, @user)
    expect(out[:status]).to eq(:success)

    invitation = Invitation.find_by(code: out[:code])
    expect(invitation.user).to eq(@user)
  end

  it "should keep only one valid invitation for each user" do
    service = Authenticates::CreateInvitationService.new
    service.execute(nil, @user)
    service.execute(nil, @user)
    service.execute(nil, @user)

    not_expired_invitations = @user.invitations.where(expired: false)
    expect(not_expired_invitations.count).to eq(1)
  end

  it "should not create invitation for a invalid user" do
    out = Authenticates::CreateInvitationService.new.execute(nil, nil)
    expect(out[:status]).to eq(:failure)
  end

  it "should move provider info when signed_in_user is not equal to user_params" do
    @another_user = FactoryGirl.create(:user, username: "Mary")
    service = Authenticates::CreateInvitationService.new
    service.execute(nil, @user)

    provider = @user.provider
    uid = @user.uid
    extra_info = @user.extra_info

    out = service.execute(@user, @another_user)

    @user.reload
    @another_user.reload

    expect(@user.provider).to eq(nil)
    expect(@user.uid).to eq(nil)
    expect(@user.extra_info).to eq(nil)

    expect(@another_user.provider).to eq(provider)
    expect(@another_user.uid).to eq(uid)
    expect(@another_user.extra_info).to eq(extra_info)
  end
end