require "rails_helper"

RSpec.describe "check reader, unreader process", type: :feature do
  before(:each) do
    authenticate_to_admin!
    @gate = FactoryGirl.create(:gate)
    @user = FactoryGirl.create(:user)
  end

  it "should let me check unreaders" do
    visit("/admin")
    click_link(@gate.title)

    expect(find('.gate-reader')).not_to have_content(@user.username)
    expect(find('.gate-unreader')).to have_content(@user.username)
  end

  it "should let me check readers" do
    @user.read!(@gate)

    visit("/admin")
    click_link(@gate.title)

    expect(find('.gate-reader')).to have_content(@user.username)
    expect(find('.gate-unreader')).not_to have_content(@user.username)
  end
end