require "rails_helper"

RSpec.describe Authenticates::CookiesSignInService do
  before(:each) do
    @club = FactoryGirl.create(:complete_club)
    @user = @club.users.first
    @cookies = {}
    @session = {}

    [:user_id, :regard_as_activated].each do |key|
      allow_any_instance_of(Authenticates::UserCookies).to receive("#{key}") do
        @cookies[key]
      end

      allow_any_instance_of(Authenticates::UserCookies).to receive("#{key}=") do |_, value|
        @cookies[key] = value
      end
    end

    Authenticates::UserCookies.new(@cookies).create!(@user, false)
  end

  it "should let me sign in with cookies" do
    out = Authenticates::CookiesSignInService.new(@club).execute(@session, @cookies)

    expect(out[:status]).to eq(:success)
    expect(@session).to include(user_id: @user.id)
  end

  it "should destroy cookies when try to sign in with invalid cookies" do
    @cookies[:user_id] = -1
    out = Authenticates::CookiesSignInService.new(@club).execute(@session, @cookies)

    expect(out[:status]).to eq(:failure)
    expect(@session.empty?).to eq(true)
  end
end