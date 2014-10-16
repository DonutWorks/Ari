require "rails_helper"

RSpec.describe "user_notice", type: :feature do
  before(:each) do
    @user = FactoryGirl.create(:user)
    authenticate_to_member!
    @notice = Notice.create(title: "notice!", content: "This is TO notice", link:"http://google.com", to: "10", notice_type: "to", due_date: "2050-1-1")
  end

  it "should let me see a TO notice" do
    visit("/notices/#{(@notice.id)}")

    expect(find('.to_p')).to have_content("TO")
  end

  it "should let me go to OK list if TO is not full" do
    visit("/notices/#{(@notice.id)}")

    expect(find('.to_p')).to have_content("TO")
  end

  it "should let me go to waiting list if TO is full" do
    visit("/notices/#{(@notice.id)}")

    expect(find('.to_p')).to have_content("TO")
  end

  it "should let me see if deadline for joining event is over" do
    visit("/notices/#{(@notice.id)}")

    expect(find('.to_p')).to have_content("TO")
  end

end