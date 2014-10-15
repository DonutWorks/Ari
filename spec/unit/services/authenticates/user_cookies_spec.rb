require "rails_helper"

RSpec.describe Authenticates::UserCookies do
  class CookiesMock
    def initialize
      @cookies = {}
    end

    def permanent
      return self
    end

    def signed
      @cookies
    end
  end

  before(:each) do
    @cookies = CookiesMock.new
  end

  it "should implement getters, setters for each storage keys" do
    user_cookies = Authenticates::UserCookies.new(@cookies)
    Authenticates::UserStorage::KEYS.each do |key|
      value = user_cookies.send("#{key}")
      expect(value).to eq(nil)

      user_cookies.send("#{key}=", "Hello")
      value = user_cookies.send("#{key}")
      expect(value).to eq("Hello")
    end
  end
end