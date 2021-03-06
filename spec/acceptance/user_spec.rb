require "rails_helper"

RSpec.describe "check user process", type: :feature do
  before(:each) do
    @club = FactoryGirl.create(:complete_club)
    authenticate_to_admin!(@club.representive)
    @user = @club.users.first
  end

  it "should show user list" do
    visit club_admin_users_path(@club)

    expect(find('.table')).to have_content(@user.username)
  end

  it "should show detail information" do
    visit club_admin_users_path(@club)
    # detail link for a first user
    find("tbody tr:first-child a").click

    expect(find('.categories')).to have_content(@user.member_type)
  end

  it "should create new user" do
    visit new_club_admin_user_path(@club)

    fill_in 'user_username', :with => 'testtest'
    fill_in 'user_phone_number', :with => '01011111111'
    fill_in 'user_email', :with => 'test@testtt.com'
    click_button "등록"

    expect(find('.alert-info')).to have_content('님의 멤버 정보 생성에 성공했습니다')
  end

  it "should not create new user (phone_number is duplicated)" do
    visit new_club_admin_user_path(@club)

    fill_in 'user_username', :with => 'testtest'
    fill_in 'user_phone_number', :with => @user.phone_number
    fill_in 'user_email', :with => 'test@testtt.com'
    click_button "등록"

    expect(find('.glyphicon-remove').parent).to have_content('이미 존재합니다')
  end

  it "should not create new user (email is duplicated)" do
    visit new_club_admin_user_path(@club)

    fill_in 'user_username', :with => 'testtest'
    fill_in 'user_phone_number', :with => '01011111111'
    fill_in 'user_email', :with => @user.email
    click_button "등록"

    expect(find('.glyphicon-remove').parent).to have_content('이미 존재합니다')
  end

  it "should not create new user (blank)" do
    visit new_club_admin_user_path(@club)

    click_button "등록"

    expect(find('form')).to have_content('내용을 입력해 주세요')
  end

  it "should create user from excel" do
    visit import_club_admin_users_path(@club)

    file_path = Rails.root + "spec/acceptance/fixtures/RosterExample.xlsx"
    attach_file('upload_file', file_path)

    click_button "업로드"

    expect(find('.alert-info')).to have_content('멤버 입력에 성공했습니다')
  end

  it "should create user from excel with striping" do
    visit import_club_admin_users_path(@club)

    file_path = Rails.root + "spec/acceptance/fixtures/RosterExample.xlsx"
    attach_file('upload_file', file_path)

    click_button "업로드"
    visit club_admin_users_path(@club)

    expect(/임수정/).to match(find('.table').text)
    expect(/ 임수정/).to match(find('.table').text)
  end

  it "should create user from excel (contains duplicated user)" do
    visit import_club_admin_users_path(@club)

    file_path = Rails.root + "spec/acceptance/fixtures/RosterExample.xlsx"
    attach_file('upload_file', file_path)

    click_button "업로드"

    expect(find('.alert-info')).to have_content('멤버 입력에 성공했습니다')

    visit import_club_admin_users_path(@club)

    file_path = Rails.root + "spec/acceptance/fixtures/RosterExample_duplicated.xlsx"
    attach_file('upload_file', file_path)

    click_button "업로드"

    expect(find('.alert-info')).to have_content('멤버 입력에 성공했습니다')
  end

  it "should not create user from excel (empty file)" do
    visit import_club_admin_users_path(@club)

    click_button "업로드"

    expect(find('.alert-danger')).to have_content('첨부파일을 업로드 하세요.')
  end

  it "should modify user" do
    visit club_admin_user_path(@club, @user)

    click_link "수정"

    fill_in 'user_username', :with => 'testtest'
    fill_in 'user_phone_number', :with => '01011111111'
    fill_in 'user_email', :with => 'test@testtt.com'
    click_button "수정"

    expect(find('.alert-info')).to have_content('멤버 정보 수정에 성공했습니다')
  end

  it "should not modify user (email is duplicated)" do
    @club.users.create(username: 'testtest', phone_number: '01011111111', email: 'test@testtt.com')

    visit club_admin_user_path(@club, @user)

    click_link "수정"

    fill_in 'user_email', :with => 'test@testtt.com'
    click_button "수정"

    expect(find('.glyphicon-remove').parent).to have_content('이미 존재합니다.')
  end

  it "should not modify user (phone_number is duplicated)" do
    @club.users.create(username: 'testtest', phone_number: '01011111111', email: 'test@testtt.com')

    visit club_admin_user_path(@club, @user)

    click_link "수정"

    fill_in 'user_phone_number', :with => '01011111111'
    click_button "수정"

    expect(find('.glyphicon-remove').parent).to have_content('이미 존재합니다.')
  end

  it "should delete user" do
    visit club_admin_user_path(@club, @user)

    click_link "삭제"
    page.driver.browser.switch_to.alert.accept if Capybara.current_driver != :rack_test

    expect(find('.alert-info')).to have_content('멤버 정보 삭제에 성공했습니다')
  end
end