require "rails_helper"

RSpec.describe Authenticates::FetchJoinedClubService do
  before(:each) do
    @club = FactoryGirl.create(:complete_club)
    @another_club = FactoryGirl.create(:club)
    @user = @club.users.first
  end

  it "should fail if phone_number is invalid" do
    out = Authenticates::FetchJoinedClubService.new.execute("00000000000")

    expect(out[:status]).to eq(:invalid_phone_number)
  end

  it "should return joined clubs" do
    # user joins another club
    @another_club.users << @user.dup

    out = Authenticates::FetchJoinedClubService.new.execute(@user.phone_number)

    joined_clubs = out[:clubs]
    expect(joined_clubs).to match_array([@club, @another_club])
  end

  it "should empty set if user is not joined any club" do
    another_user = FactoryGirl.create(:user, club: @club)

    out = Authenticates::FetchJoinedClubService.new.execute(another_user.phone_number)

    joined_clubs = out[:clubs]
    expect(joined_clubs).not_to include(@another_club)
  end
end