require "rails_helper"

RSpec.describe Authenticates::KakaoSignInService do
  before(:each) do
    @auth_hash = {
      "provider" => "kakao",
      "uid" => "1234",
      "info" => {
        "name" => "Hello"
      }
    }
    @user_params = @auth_hash.dup
    @user_params["extra_info"] = @user_params.delete("info")
    @session = {}
  end

  it "should lead invitation page if not found a user matching with auth hash" do
    out = Authenticates::KakaoSignInService.new.execute(@session, @auth_hash)

    expect(out[:status]).to eq(:need_to_register)
    expect(@session.empty?).to eq(true)
  end

  it "should create user session" do
    user = FactoryGirl.create(:user, @user_params)
    out = Authenticates::KakaoSignInService.new.execute(@session, @auth_hash)

    expect(out[:status]).to eq(:success)
    expect(@session[:user_id]).to eq(user.id)
  end

  it "should update user extra_info" do
    user = FactoryGirl.create(:user, @user_params)
    Authenticates::KakaoSignInService.new.execute(@session, @auth_hash)
    user.reload

    expect(user.extra_info["name"]).to eq("Hello")

    @auth_hash["info"]["name"] = "World"
    Authenticates::KakaoSignInService.new.execute(@session, @auth_hash)
    user.reload

    expect(user.extra_info["name"]).to eq("World")
  end
end