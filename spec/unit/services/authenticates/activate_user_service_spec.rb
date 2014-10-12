require "rails_helper"

RSpec.describe Authenticates::ActivateUserService do
  it "should activate a user by using activation code"
  it "should not activate a user with invalid activation code"
  it "should not activate a user with expired ticket"
  it "should expire activated ticket"
end