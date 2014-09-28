require "rails_helper"

RSpec.describe UserActivator do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @provider_token = FactoryGirl.create(:provider_token)
    @activator = UserActivator.new
  end

  describe "#issue_ticket" do
    it "should issue a ticket for a user" do
      ticket = @activator.issue_ticket(@user, @provider_token)

      expect(ticket.nil?).to eq(false)
      expect(ticket.account_activation.user).to eq(@user)
    end

    it "should create only one activation for each user" do
      ticket = @activator.issue_ticket(@user, @provider_token)
      ticket = @activator.issue_ticket(@user, @provider_token)

      expect(AccountActivation.where(user: @user).count).to eq(1)
    end

    it "should issue only one ticket for each user" do
      ticket1 = @activator.issue_ticket(@user, @provider_token)
      ticket2 = @activator.issue_ticket(@user, @provider_token)

      expect(ticket1).to eq(ticket2)
    end

    it "should not issue ticket for a invalid user" do
      ticket = @activator.issue_ticket(nil, @provider_token)
      expect(ticket).to eq(nil)
    end
  end

  describe "#activate" do
    it "should activate a user by using activation code" do
      ticket = @activator.issue_ticket(@user, @provider_token)
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
      ticket = @activator.issue_ticket(@user, @provider_token)
      activation = ticket.account_activation

      @activator.activate(ticket.code)
      activation.reload

      expect(activation.activation_ticket).to eq(nil)
    end
  end
end