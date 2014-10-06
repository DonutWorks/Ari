require "rails_helper"

RSpec.describe "kakao auth process", type: :feature do
  before(:each) do
    @user = FactoryGirl.create(:user)
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:kakao, {
      provider: "kakao",
      uid: "1234",
      info: {
        name: "John Doe",
        image: "http://donut-ari.herokuapp.com"
      }
    })
  end

  it "lets me fail to kakao log in" do
    OmniAuth.config.mock_auth[:kakao] = :invalid_credentials
    visit("/")
    find("#login-form a").click
  end

  it "leads me to email verification page at first log in" do
    visit("/")
    find("#login-form a").click
    expect(page).to have_content("John Doe")
    expect(page).to have_selector("#account_activation_email")
  end

  it "sends activation ticket to me" do
    user = nil
    activation_url = nil
    allow_any_instance_of(UserActivator).to receive(:send_ticket_mail) do |activator, receiver, url|
      user = receiver
      activation_url = url
    end

    visit("/")
    find("#login-form a").click
    fill_in 'account_activation_email', with: @user.email
    click_button "인증 메일 보내기"

    expect(user).to eq(@user)

    url = URI(activation_url)
    expect(url.path.split("/")[1]).to eq("activations")
  end

  it "show me error message when I submitted an invalid email" do
    visit("/")
    find("#login-form a").click
    fill_in 'account_activation_email', with: "invalid email"
    click_button "인증 메일 보내기"

    expect(page).to have_content("등록된 이메일이 아닙니다.")
  end

  it "lets me activate my account to click activation link"
  it "shows me error message when I clicked an invalid activation link"
  it "sends activation ticket whenever I requested a ticket"
  it "leads me to not auth page when I logged in"
  it "lets me correct connection between kakao account and email"
end