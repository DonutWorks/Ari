require "rails_helper"

RSpec.describe "kakao auth process", type: :feature do
  it "lets me fail to kakao log in"
  it "leads me to email verification page at first log in"
  it "sends activation ticket to me"
  it "show me error message when I submitted an invalid email"
  it "lets me activate my account to click activation link"
  it "shows me error message when I clicked an invalid activation link"
  it "sends activation ticket whenever I requested a ticket"
  it "leads me to not auth page when I logged in"
  it "lets me correct connection between kakao account and email"
end