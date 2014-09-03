class ImportexcelController < ApplicationController
  def import
    data = Roo::Excelx.new("app/assets/test.xlsx")
    data.default_sheet = data.sheets.first

    lastRow = data.last_row
    lastColumn = data.last_column

    @contents = []
    for i in 1..lastRow do
      for j in 1..lastColumn do
        @contents.push(data.cell(i, j))
       end
     end
  end
end
