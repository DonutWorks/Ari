require "rails_helper"

RSpec.describe "gate list", type: :feature do
  before(:each) do
    authenticate_to_admin!
    @gate = FactoryGirl.create(:gate)
    @user = FactoryGirl.create(:user)
  end

  it "should let me read gate lists" do
    visit("/admin")

    expect(find('#notice-container')).to have_content(@gate.title)

  end

end