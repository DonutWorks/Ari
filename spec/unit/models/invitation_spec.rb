require "rails_helper"

RSpec.describe Invitation, :type => :model do
  it "should generate a unique code" do
    invitation = Invitation.create!
    another_invitation = Invitation.create!

    expect(invitation.code).not_to eq(another_invitation.code)
  end

  it "should generate a code before create" do
    invitation = Invitation.new
    expect(invitation.code).to eq(nil)

    invitation.save!
    expect(invitation.code).not_to eq(nil)
  end
end