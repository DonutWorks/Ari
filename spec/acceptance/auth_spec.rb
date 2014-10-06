require "rails_helper"

RSpec.describe "the signin process", type: :feature do
  before(:each) do
    authenticate_to_admin!
  end

  it "signs me in" do
    visit '/admin'
    expect(page).to have_content 'SNU-Habitat'
  end
end