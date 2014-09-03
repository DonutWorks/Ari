class ImportexcelController < ApplicationController

  def import
    data = Roo::Excelx.new("app/assets/test.xlsx")
    data.default_sheet = data.sheets.first

    lastRow = data.last_row
    lastColumn = data.last_column

    for i in 2..lastRow do
      user = User.new
      user.username = data.cell(i, 1)
      user.email = data.cell(i, 3)
      user.password = "testtest"
    end
    redirect_to root_path
  end

  def destroy
    User.delete_all
    redirect_to root_path
  end

end
