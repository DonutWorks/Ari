require "rails_helper"

RSpec.describe BankAccountParser::ShinhanParser do
  describe "#parse_records" do
    it "should parse records in file successfully" do
      file = Roo::Excelx.new("#{Rails.root}/public/account_example_for_test.xlsx")
      file.default_sheet = file.sheets.first
      result = BankAccountParser::ShinhanParser.parse_records(file)

      d = Date.parse("2014-10-25")
      t = Time.parse("18:58:06").utc
      dt = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec)

      expect(result).to eq([{
        record_date: dt,
        withdraw: "0",
        deposit: "20000",
        content: "김민혁"}])
    end
  end
end