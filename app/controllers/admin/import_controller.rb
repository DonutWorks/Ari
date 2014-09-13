class Admin::ImportController < Admin::ApplicationController

  def new
    
  end

  def create
    file = Tempfile.new(['data','.xlsx'])
    file.binmode
    file.write(params[:upload][:file].read)

    data = Roo::Excelx.new(file.path)
    data.default_sheet = data.sheets.first

    lastRow = data.last_row
    lastColumn = data.last_column

    begin
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
      flash[:notice] = "멤버 입력을 성공 했습니다."
    rescue ActiveRecord::StatementInvalid
      flash[:notice] = "멤버 입력에 실패 했습니다."
    end

    redirect_to admin_users_index_path
  end
end
