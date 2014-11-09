require "rails_helper"

RSpec.describe Response, :type => :model do
  it "should check validation" do
    expect(Response.new).to be_invalid
    expect(FactoryGirl.build(:response, status: "false")).to be_invalid
    expect(FactoryGirl.build(:response, user: nil)).to be_invalid
    expect(FactoryGirl.build(:response, notice: nil)).to be_invalid

    expect(FactoryGirl.build(:response, status: "yes")).to be_valid
    expect(FactoryGirl.build(:response, status: "maybe")).to be_valid
    expect(FactoryGirl.build(:response, status: "no")).to be_valid
    expect(FactoryGirl.build(:response, status: "go")).to be_valid
    expect(FactoryGirl.build(:response, status: "wait")).to be_valid
  end

  it "should be created to notice only once for each user" do
    club = FactoryGirl.create(:complete_club)
    notice = FactoryGirl.create(:to_notice, club: club)
    user = club.users.first

    response = FactoryGirl.build(:response, notice: notice, user: user)
    expect(response).to be_valid
    response.save!

    reduntant_response = FactoryGirl.build(:response, notice: notice, user: user)
    expect(reduntant_response).to be_invalid

    another_notice = FactoryGirl.create(:to_notice, club: club)
    another_response = FactoryGirl.build(:response, notice: another_notice, user: user)
    expect(another_response).to be_valid
  end
end