require "rails_helper"

RSpec.describe "the signin process", type: :feature do
  before(:each) do
    @club = FactoryGirl.create(:club)
    # password = 12345678 from factories.rb
    @admin_user = FactoryGirl.create(:admin_user, club: @club)
    @another_club = FactoryGirl.create(:club)
    # authenticate_to_admin!(@club.representive)
  end

  it "should not sign me in with invalid account" do
    visit club_admin_root_path(@club)
    fill_in :admin_user_email, with: @club.representive.email
    fill_in :admin_user_password, with: "123456789"
    click_button "로그인"

    expect(page).to have_content "이메일 주소나 비밀번호가 틀립니다."
  end

  it "should not sign me in another club" do
    visit club_admin_root_path(@another_club)
    fill_in :admin_user_email, with: @club.representive.email
    fill_in :admin_user_password, with: "12345678"
    click_button "로그인"

    expect(page).to have_content "이메일 주소나 비밀번호가 틀립니다."
  end

  context "when I signed in" do
    before(:each) do
      visit club_admin_root_path(@club)
      fill_in :admin_user_email, with: @club.representive.email
      fill_in :admin_user_password, with: "12345678"
      click_button "로그인"
    end

    it "should show club admin page" do
      expect(page).to have_content @club.name
    end

    it "should prevent me from accessing another club" do
      visit club_admin_root_path(@another_club)

      expect(page).to have_content("존재하지 않는 동아리입니다.")
    end

    it "redirect me club admin sign in page after sign out" do
      click_link "로그아웃"

      expect(current_path).to eq(new_admin_user_session_path(@club))
    end
  end
end