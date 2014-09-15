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

    User.transaction do
      (2..lastRow).each do |i|
        user = User.new
        user.group_id = data.cell(i, 1)
        user.major = data.cell(i, 2)
        user.student_id = data.cell(i, 3)
        user.sex = data.cell(i, 4)
        user.username = data.cell(i, 5)
        user.home_phone_number = data.cell(i, 6)
        user.phone_number = data.cell(i, 7)
        user.emergency_phone_number = data.cell(i, 8)
        user.email = data.cell(i, 9)
        user.habitat_id = data.cell(i, 10)
        user.member_type = data.cell(i, 11)
        user.password = "testtest"
        user.save!
      end
    end

    flash[:notice] = "멤버 입력을 성공 했습니다."
    redirect_to admin_root_path

  rescue ActiveRecord::RecordInvalid
    flash[:notice] = "멤버 입력에 실패 했습니다."
  end
end