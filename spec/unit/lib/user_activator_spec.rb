require "rails_helper"

RSpec.describe UserActivator do
  before(:each) do
    @auth_hash = {
      uid: 1234,
      provider: "kakao"
    }
    @activator = UserActivator.new
  end

  describe "#issue_ticket" do
    it "should issue a ticket for a user" do
      user = FactoryGirl.create(:user)
      ticket = @activator.issue_ticket(user, @auth_hash)

      expect(ticket.nil?).to eq(false)
      expect(ticket.account_activation.user).to eq(user)
    end

    it "should create only one activation for each user" do
      user = FactoryGirl.create(:user)
      ticket = @activator.issue_ticket(user, @auth_hash)
      ticket = @activator.issue_ticket(user, @auth_hash)

      expect(AccountActivation.where(user: user).count).to eq(1)
    end

    it "should issue only one ticket for each user" do
      user = FactoryGirl.create(:user)
      ticket1 = @activator.issue_ticket(user, @auth_hash)
      ticket2 = @activator.issue_ticket(user, @auth_hash)

      expect(ticket1).to eq(ticket2)
    end

    it "should not issue ticket for a invalid user" do
      ticket = @activator.issue_ticket(nil, @auth_hash)
      expect(ticket).to eq(nil)
    end
  end

  describe "#activate" do
    it "should activate a user by using activation code" do
      user = FactoryGirl.create(:user)
      ticket = @activator.issue_ticket(user, @auth_hash)
      activation = ticket.account_activation

      expect(activation.activated).to eq(false)

      success = @activator.activate(ticket.code)
      expect(success).to eq(true)

      activation.reload
      expect(activation.activated).to eq(true)
    end

    it "should not activate a user with invalid activation code" do
      success = @activator.activate(1234)
      expect(success).to eq(false)
    end

    it "should destroy activated ticket" do
      user = FactoryGirl.create(:user)
      ticket = @activator.issue_ticket(user, @auth_hash)
      activation = ticket.account_activation

      @activator.activate(ticket.code)
      activation.reload

      expect(activation.activation_ticket).to eq(nil)
    end
  end
end