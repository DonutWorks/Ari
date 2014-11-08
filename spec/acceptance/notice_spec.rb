require "rails_helper"

RSpec.describe "notice", type: :feature do
  before(:each) do
    @club = FactoryGirl.create(:complete_club)
    authenticate_to_admin!(@club.representive)

    raise "need to modify activity factory"
    @activity = FactoryGirl.create(:activity)
    @notice = @club.notices.first
    @user = @club.users.first
  end

  after(:each) do
    Warden.test_reset!
  end

  it "should let me see a notice lists" do
    visit club_admin_root_path(@club)

    expect(find('#notice-container')).to have_content(@notice.title)
  end

  it "should let me read a notice" do
    visit club_admin_root_path(@club)
    click_link @notice.title

    expect(find('.page-header.clearfix')).to have_content(@notice.title)
  end

  it "should let me add a new notice" do
    visit new_club_admin_notice_path(@club)

    fill_in 'notice_title', :with => 'Protoss noticeway'
    fill_in 'notice_content', :with => 'Costs 150 mineral'
    fill_in 'notice_link', :with => 'www.starcraft.com'
    click_button "등록"

    expect(find('.page-header.clearfix')).to have_content('Protoss noticeway')
  end

  it "should let me fail to add a new notice when I forget to fill in" do
    visit new_club_admin_notice_path(@club)

    click_button "등록"

    expect(page).to have_selector('#new_notice')
    expect(page).to have_selector('.field_with_errors')
  end


  it "should let me modify the new notice" do
    visit edit_club_admin_notice_path(@club, @notice)

    fill_in 'notice_title', :with => 'Protoss noticeway'
    fill_in 'notice_content', :with => 'Costs 150 mineral'
    fill_in 'notice_link', :with => 'www.starcraft.com'
    click_button "수정"

    expect(find('.page-header.clearfix')).to have_content('Protoss noticeway')
  end

  it "should let me fail to modify a new notice when I forget to fill in" do
    visit edit_club_admin_notice_path(@club, @notice)

    fill_in 'notice_title', :with => ''
    fill_in 'notice_content', :with => ''
    fill_in 'notice_link', :with => ''
    click_button "수정"

    select_query = "#edit_notice_#{@notice.id}"
    expect(page).to have_selector(select_query)
    expect(page).to have_selector('.field_with_errors')
  end




  it "should let me check unreaders" do
    visit club_admin_root_path(@club)
    click_link @notice.title

    expect(find('.notice-reader')).not_to have_content(@user.username)
    expect(find('.notice-unreader')).to have_content(@user.username)
  end

  it "should let me check readers" do
    @user.read!(@notice)

    visit club_admin_root_path(@club)
    click_link @notice.title

    expect(find('.notice-reader')).to have_content(@user.username)
    expect(find('.notice-unreader')).not_to have_content(@user.username)
  end

  it "should let me delete the notice" do
    visit club_admin_root_path(@club)

    expect(find('#notice-container')).to have_content(@notice.title)

    visit club_admin_notice_path(@club, @notice)

    click_link('삭제')
    # page.driver.browser.switch_to.alert.accept

    expect(page).to have_selector('.alert')
    expect(page).to have_selector('#notice-container')
    expect(find('#notice-container')).not_to have_content(@notice.title)
  end

  context "when I update a TO notice" do
    before(:each) do
      raise "Need to modify test, factory"
      @to_notice = FactoryGirl.create(:to_notice, to: 3, title: "TO notice", club: @club, activity: @activity)
      @users = FactoryGirl.create_list(:user, 2)

      @club.users.first(2).each do |user|
        @club.responses.create!(user: user, notice: @to_notice, status: "go")
      end

      visit club_admin_root_path(@club)
      click_link @to_notice.title
      click_link "수정"
    end

    it "should let me decrease TO (greater than responses)" do
      fill_in :notice_to, with: 2
      click_button "수정"

      expect(page).to have_content("성공적으로 수정했습니다.")
    end

    it "should show errors when I decrease TO (less than responses)" do
      fill_in :notice_to, with: 1
      click_button "수정"

      expect(page).to have_content("현재 참석자가 설정된 모집 인원보다 많습니다.")
    end

    it "should let me increase TO" do
      fill_in :notice_to, with: 4
      click_button "수정"

      expect(page).to have_content("성공적으로 수정했습니다.")
    end
  end
end