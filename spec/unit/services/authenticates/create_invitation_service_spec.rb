require "rails_helper"

RSpec.describe Authenticates::CreateInvitationService do
  it "should issue a ticket for a user"
  it "should keep only one valid ticket for each user"
  it "should not issue ticket for a invalid user"
end