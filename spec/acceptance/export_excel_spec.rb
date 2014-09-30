require "rails_helper"

RSpec.describe "download exported excel", type: :feature do
  before(:each) do
    authenticate_to_admin!
  end

  it "should let me download survey list to excel" do

    file_path = Rails.root.join("public", "test", "comments-excel.xls")
    
    visit("/admin/export_excel/new?is_test=true")

    fill_in 'notice_link', :with => 'http://club.cyworld.com/52252462136/157156013'
    click_button '저장하기'

    expect(File.read(file_path))

    File.delete(file_path) if File.exist?(file_path)

  end

  it "should let me show error message when url is not valid" do

    visit("/admin/export_excel/new")

    fill_in 'notice_link', :with => 'http://club.cyworld.com'
    click_button '저장하기'

    expect(page).to have_selector('.alert-danger')

  end

  it "should let me show error message when url is empty" do

    visit("/admin/export_excel/new")

    fill_in 'notice_link', :with => ''
    click_button '저장하기'

    expect(page).to have_selector('.alert-danger')

  end

  it "should let me show invalid format when data is invalid" do

    file_path = Rails.root.join("public", "test", "comments-excel.xls")

    visit("/admin/export_excel/new?is_test=true")

    fill_in 'notice_link', :with => 'http://club.cyworld.com/52252462136/157187979'
    click_button '저장하기'

    data = Roo::Spreadsheet.open("./public/test/comments-excel.xls")
    data.default_sheet = data.sheets.first

    expect(data.cell(2,2)).not_to eq(nil)
    expect(data.cell(3,2)).to eq(nil)

    File.delete(file_path) if File.exist?(file_path)

  end

  it "should let me show invalid format when all data is invalid" do

    file_path = Rails.root.join("public", "test", "comments-excel.xls")

    visit("/admin/export_excel/new?is_test=true")

    fill_in 'notice_link', :with => 'http://club.cyworld.com/522524621266/157150073'
    click_button '저장하기'

    data = Roo::Spreadsheet.open("./public/test/comments-excel.xls")
    data.default_sheet = data.sheets.first

    expect(data.cell(1,2)).to eq(nil)
    expect(data.cell(2,2)).to eq(nil)
    expect(data.cell(3,2)).to eq(nil)
    expect(data.cell(1,1)).not_to eq(nil)
    expect(data.cell(2,1)).not_to eq(nil)
    expect(data.cell(3,1)).not_to eq(nil)

    File.delete(file_path) if File.exist?(file_path)

  end

  it "should let me show data when count of data is more than 50" do

    file_path = Rails.root.join("public", "test", "comments-excel.xls")

    visit("/admin/export_excel/new?is_test=true")

    fill_in 'notice_link', :with => 'http://club.cyworld.com/52252462136/156085537'
    click_button '저장하기'

    data = Roo::Spreadsheet.open("./public/test/comments-excel.xls")
    data.default_sheet = data.sheets.first

    expect(data.last_row).to be > 50

    File.delete(file_path) if File.exist?(file_path)

  end

end