require "rails_helper"

RSpec.describe "the signin process", type: :feature do
  before(:each) do
    @club = FactoryGirl.create(:complete_club)
    authenticate_to_admin!(@club.representive)
  end

  after(:each) do
    Warden.test_reset!
  end

  it "signs me in" do
    visit club_admin_root_path(@club)
    expect(page).to have_content @club.name
  end
end