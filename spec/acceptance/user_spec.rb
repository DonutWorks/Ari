require "rails_helper"

RSpec.describe "check user process", type: :feature do
  before(:each) do
    authenticate_to_admin!
    @gate = FactoryGirl.create(:gate)
    @user = FactoryGirl.create(:user)
  end

  it "should show user list" do
    visit("/admin/users")

    expect(find('.table')).to have_content(@user.username)
  end

  it "should show detail information" do
    visit("/admin/users")
    click_link('자세히')

    expect(find('.table')).to have_content(@user.username)
  end

  it "should create new user" do
    visit("/admin/users/new")

    fill_in 'user_username', :with => 'testtest'
    fill_in 'user_phone_number', :with => '01011111111'
    fill_in 'user_email', :with => 'test@testtt.com'
    click_button "등록"

    expect(User.find(2).username).to eq('testtest')
  end

  it "should not create new user (phone_number is duplicated)" do
    visit("/admin/users/new")

    fill_in 'user_username', :with => 'testtest'
    fill_in 'user_phone_number', :with => @user.phone_number
    fill_in 'user_email', :with => 'test@testtt.com'
    click_button "등록"

    expect(User.find(1).username).not_to eq('testtest')
  end

  it "should not create new user (email is duplicated)" do
    visit("/admin/users/new")

    fill_in 'user_username', :with => 'testtest'
    fill_in 'user_phone_number', :with => '01011111111'
    fill_in 'user_email', :with => @user.email
    click_button "등록"

    expect(User.find(1).username).not_to eq('testtest')
  end

  it "should not create new user (blank)" do
    visit("/admin/users/new")

    expect(User.count).to eq(1)

    click_button "등록"

    expect(User.count).to eq(1)
  end

  it "should create user from excel" do
    visit import_admin_users_path

    expect(User.count).to eq(1)

    file_path = Rails.root + "spec/acceptance/fixtures/RosterExample.xlsx"
    attach_file('upload_file', file_path)

    click_button "업로드"

    expect(User.count).to eq(3)
  end

  it "should create user from excel (contains duplicated user)" do
    visit import_admin_users_path

    file_path = Rails.root + "spec/acceptance/fixtures/RosterExample.xlsx"
    attach_file('upload_file', file_path)

    click_button "업로드"

    expect(User.find_by_username("김태희").home_phone_number).to eq('031-222-1111')

    visit import_admin_users_path

    file_path = Rails.root + "spec/acceptance/fixtures/RosterExample_duplicated.xlsx"
    attach_file('upload_file', file_path)

    click_button "업로드"

    expect(User.find_by_username("김태희").home_phone_number).to eq('031-222-2222')
  end

  it "should not create user from excel (empty file)" do
    visit import_admin_users_path

    click_button "업로드"

    expect(find('.alert-danger')).to have_content('첨부파일을 업로드 하세요.')
  end

  it "should modify user" do
    visit("/admin/users/1")

    expect(User.find(1).username).to eq(@user.username)
    expect(User.find(1).phone_number).to eq(@user.phone_number)
    expect(User.find(1).email).to eq(@user.email)

    click_link('수정')

    fill_in 'user_username', :with => 'testtest'
    fill_in 'user_phone_number', :with => '01011111111'
    fill_in 'user_email', :with => 'test@testtt.com'
    click_button "수정"

    expect(User.find(1).username).to eq('testtest')
    expect(User.find(1).phone_number).to eq('01011111111')
    expect(User.find(1).email).to eq('test@testtt.com')
  end

  it "should not modify user (email is duplicated)" do

    User.create(username: 'testtest', phone_number: '01011111111', email: 'test@testtt.com')

    visit("/admin/users/1")

    expect(User.find(1).username).to eq(@user.username)
    expect(User.find(1).phone_number).to eq(@user.phone_number)
    expect(User.find(1).email).to eq(@user.email)

    click_link('수정')

    fill_in 'user_email', :with => 'test@testtt.com'
    click_button "수정"

    expect(User.find(1).email).to eq(@user.email)
  end

  it "should not modify user (phone_number is duplicated)" do

    User.create(username: 'testtest', phone_number: '01011111111', email: 'test@testtt.com')

    visit("/admin/users/1")

    expect(User.find(1).username).to eq(@user.username)
    expect(User.find(1).phone_number).to eq(@user.phone_number)
    expect(User.find(1).email).to eq(@user.email)

    click_link('수정')

    fill_in 'user_phone_number', :with => '01011111111'
    click_button "수정"

    expect(User.find(1).phone_number).to eq(@user.phone_number)
  end

  it "should delete user" do
    visit("/admin/users/1")

    expect(User.count).to eq(1)

    method = find('.btn-danger')['data-method']
    href = find('.btn-danger')['href']

    page.driver.submit method, href, {}

    expect(User.count).to eq(0)
  end
end