require "rails_helper"

RSpec.describe Authenticates::UserSession do
  before(:each) do
    @session = {}
    @user = FactoryGirl.create(:user)
  end

  describe "#create!" do
    it "should create a user session" do
      Authenticates::UserSession.new(@session).create!(@user, true)

      expect(@session[:user_id]).to eq(@user.id)
      expect(@session[:regard_as_activated]).to eq(true)
    end
  end

  describe "#destroy!" do
    it "should destroy a user session" do
      user_session = Authenticates::UserSession.new(@session)
      user_session.create!(@user, true)
      expect(@session.empty?).to eq(false)

      user_session.destroy!
      expect(@session.compact.empty?).to eq(true)
    end
  end

  describe "#user" do
    it "should return a user in session" do
      user_session = Authenticates::UserSession.new(@session)
      user_session.create!(@user, true)

      expect(user_session.user).to eq(@user)
    end

    it "should return a user with regard_as_activated" do
      expect(@user.regard_as_activated).to eq(nil)

      user_session = Authenticates::UserSession.new(@session)
      user_session.create!(@user, true)

      expect(user_session.user.regard_as_activated).to eq(true)
    end

    it "should nil when not found user" do
      user_session = Authenticates::UserSession.new(@session)
      user = @user.dup
      user.id = -1
      user_session.create!(user, true)

      expect(user_session.user).to eq(nil)
    end
  end
end