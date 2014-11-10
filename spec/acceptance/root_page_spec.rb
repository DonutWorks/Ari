require "rails_helper"

RSpec.describe "root page", type: :feature do
  before(:each) do
    @club = FactoryGirl.create(:complete_club)
    @user = @club.users.first
    @another_club = FactoryGirl.create(:club)
  end

  context "when user is signed in" do
    before(:each) do
      visit club_path(@club)
      fill_in :user_phone_number, with: @user.phone_number
      click_button "전화번호로 로그인"
    end

    it "should redirect joined club root page when user accesses root page" do
      visit root_path

      expect(current_path).to eq(club_path(@club))
    end
  end

  context "when user is not signed in" do
    it "should sign me in club I joined only" do
      visit root_path
      fill_in :user_phone_number, with: @user.phone_number
      click_button "전화번호로 로그인"

      expect(current_path).to eq(club_path(@user.club))
      expect(page).to have_content("@ #{@user.club.name}")
    end

    it "should show me clubs I joined" do
      @another_club.users << @user.dup

      visit root_path
      fill_in :user_phone_number, with: @user.phone_number
      click_button "전화번호로 로그인"

      click_button @user.club.name
      expect(page).to have_content("@ #{@user.club.name}")
    end
  end
end