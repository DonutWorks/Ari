require "rails_helper"

RSpec.describe Authenticates::UserSession do
  before(:each) do
    @session = {}
  end

  it "should implement getters, setters for each storage keys" do
    user_session = Authenticates::UserSession.new(@session)
    Authenticates::UserStorage::KEYS.each do |key|
      value = user_session.send("#{key}")
      expect(value).to eq(nil)

      user_session.send("#{key}=", "Hello")
      value = user_session.send("#{key}")
      expect(value).to eq("Hello")
    end
  end
end