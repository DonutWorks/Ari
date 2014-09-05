class ImportExcelController < ApplicationController
  skip_before_action :authenticate_user!

  def import
    data = Roo::Excelx.new("app/assets/test.xlsx")
    data.default_sheet = data.sheets.first

    lastRow = data.last_row
    lastColumn = data.last_column

    User.transaction do 
      (2..lastRow).each do |i|
        user = User.new
        user.username = data.cell(i, 1)
        user.phonenumber = data.cell(i, 2)
        user.email = data.cell(i, 3)
        user.major = data.cell(i, 4)
        user.password = "testtest"
        user.save!
      end
    end
    rescue ActiveRecord::StatementInvalid
      
    end
    redirect_to root_path
  end

  def destroy
    User.delete_all
    redirect_to root_path
  end
end