require "rails_helper"

RSpec.describe Authenticates::PhoneNumberSignInService do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @session = {}
  end

  it "should create user session with valid phone number" do
    out = Authenticates::PhoneNumberSignInService.new.execute(@session, @user.phone_number)
    expect(out[:status]).to eq(:success)
  end

  it "should fail to create user session with invalid phone number" do
    out = Authenticates::PhoneNumberSignInService.new.execute(@session, @user.phone_number + "0")
    expect(out[:status]).to eq(:invalid_phone_number)
  end
end