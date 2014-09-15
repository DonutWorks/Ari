require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  describe "GET show" do
    it "returns http success" do
      user = FactoryGirl.create(:user)
      sign_in user

      get :show
      expect(response).to be_success
    end
  end
end