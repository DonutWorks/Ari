require "rails_helper"

RSpec.describe "the signin process", :type => :feature do
  def authenticate(name, password)
    if page.driver.respond_to?(:basic_auth)
      page.driver.basic_auth(name, password)
    elsif page.driver.respond_to?(:basic_authorize)
      page.driver.basic_authorize(name, password)
    elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
      page.driver.browser.basic_authorize(name, password)
    else
      raise "I don't know how to log in!"
    end
  end

  it "signs me in" do
    authenticate("habitat", "iloveyou")

    visit '/admin'

    expect(page).to have_content 'SNU-Habitat'
  end
end