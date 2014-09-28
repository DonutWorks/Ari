require "rails_helper"
require "database_cleaner"

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

RSpec.describe "gate", type: :feature do

  it "should let me delete the gate",  :js => true,  :driver => :selenium do

    page.visit("http://habitat:iloveyou@localhost:#{Capybara.current_session.server.port}/admin")
    visit("http://localhost:#{Capybara.current_session.server.port}/admin/gates/new")

    fill_in 'gate_title', :with => 'Protoss gateway'
    fill_in 'gate_content', :with => 'Costs 150 mineral'
    fill_in 'gate_link', :with => 'www.starcraft.com'
    click_button "등록"

    click_link('삭제')
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_selector('.alert')
    expect(page).to have_selector('#notice-container')
    expect(find('#notice-container')).not_to have_content('Protoss gateway')
  end

end
