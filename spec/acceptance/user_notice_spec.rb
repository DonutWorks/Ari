require "rails_helper"

RSpec.describe "user_notice", type: :feature do
  before(:each) do
    @club = FactoryGirl.create(:complete_club)
    @user = @club.users.first
    authenticate_user!(@user)

    @notice = FactoryGirl.create(:to_notice, to: 1, activity: @club.activities.first)

  end

  it "should let me see a TO notice" do
    visit("/notices/#{(@notice.id)}")

    expect(page).to have_content("참가하기")
  end

  it "should let me go to OK list if TO is not full" do
    visit("/notices/#{(@notice.id)}")

    click_button "참가하기"

    expect(find('.alert-info')).to have_content("참석자로 등록 되었습니다.")
  end

  it "should let me go to waiting list if TO is full" do
    user_test = @club.users.create(username: "Sam", email: "test@donutworks.com", phone_number: "010-3333-2222")
    @club.responses.create(notice: @notice, user: user_test, status: "go")

    visit("/notices/#{(@notice.id)}")
    click_button "참가하기"

    expect(find('.alert-info')).to have_content("대기자로 등록 되었습니다.")
  end

  it "should let me see if deadline for joining event is over" do
    @notice.update(due_date: "2011-1-1")
    visit("/notices/#{(@notice.id)}")

    expect(find('.mention')).to have_content("")

    @notice.update(due_date: "2050-1-1")
  end

end