require "rails_helper"

RSpec.describe "gate", type: :feature do
  before(:each) do
    authenticate_to_admin!
    @gate = FactoryGirl.create(:gate)
    @user = FactoryGirl.create(:user)
  end

  it "should let me see a gate lists" do

    visit("/admin")

    expect(find('#notice-container')).to have_content(@gate.title)
  end

  it "should let me read a gate" do
    visit("/admin")
    click_link(@gate.title)

    expect(find('.page-header.clearfix')).to have_content(@gate.title)
  end

  it "should let me add a new gate" do
    visit("/admin/gates/new")

    fill_in 'gate_title', :with => 'Protoss gateway'
    fill_in 'gate_content', :with => 'Costs 150 mineral'
    fill_in 'gate_link', :with => 'www.starcraft.com'
    click_button "등록"

    expect(find('.page-header.clearfix')).to have_content('Protoss gateway')
  end

  it "should let me fail to add a new gate when I forget to fill in" do
    visit("/admin/gates/new")

    click_button "등록"

    expect(page).to have_selector('#new_gate')
    expect(page).to have_selector('.field_with_errors')
  end


  it "should let me modify the new gate" do
    visit("/admin/gates/#{@gate.id}/edit")

    fill_in 'gate_title', :with => 'Protoss gateway'
    fill_in 'gate_content', :with => 'Costs 150 mineral'
    fill_in 'gate_link', :with => 'www.starcraft.com'
    click_button "수정"

    expect(find('.page-header.clearfix')).to have_content('Protoss gateway')
  end

  it "should let me fail to modify a new gate when I forget to fill in" do
    visit("/admin/gates/#{@gate.id}/edit")

    fill_in 'gate_title', :with => ''
    fill_in 'gate_content', :with => ''
    fill_in 'gate_link', :with => ''
    click_button "수정"

    select_query = "#edit_gate_#{@gate.id}"
    expect(page).to have_selector(select_query)
    expect(page).to have_selector('.field_with_errors')
  end




  it "should let me check unreaders" do
    visit("/admin")
    click_link(@gate.title)

    expect(find('.gate-reader')).not_to have_content(@user.username)
    expect(find('.gate-unreader')).to have_content(@user.username)
  end

  it "should let me check readers" do
    @user.read!(@gate)

    visit("/admin")
    click_link(@gate.title)

    expect(find('.gate-reader')).to have_content(@user.username)
    expect(find('.gate-unreader')).not_to have_content(@user.username)
  end

  it "should let me delete the gate" do
  # it "should let me delete the gate" do

    visit("/admin")
    expect(find('#notice-container')).to have_content(@gate.title)

    visit("/admin/gates/#{@gate.id}")

    click_link('삭제')
    # page.driver.browser.switch_to.alert.accept

    expect(page).to have_selector('.alert')
    expect(page).to have_selector('#notice-container')
    expect(find('#notice-container')).not_to have_content(@gate.title)
  end

end