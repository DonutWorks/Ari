class Admin::ImportController < Admin::ApplicationController

  def new
    @invalid_users = []
    @invalid_ids = []
  end

  def create
    file = Tempfile.new(['data','.xlsx'])
    file.binmode
    file.write(params[:upload][:file].read)

    data = Roo::Excelx.new(file.path)
    data.default_sheet = data.sheets.first

    lastRow = data.last_row
    lastColumn = data.last_column

    @invalid_users = []
    @invalid_ids = []
    normalizer = FormNormalizer.new

    (2..lastRow).each do |i|
      user = User.new

      user.group_id = normalizer.normalize("기수", data.cell(i, 1))
      user.major = data.cell(i, 2)
      user.student_id = data.cell(i, 3)
      user.sex = normalizer.normalize("성별", data.cell(i, 4))
      user.username = data.cell(i, 5)
      user.home_phone_number = normalizer.normalize("전화", data.cell(i, 6))
      user.phone_number = normalizer.normalize("전화", data.cell(i, 7))
      user.emergency_phone_number = normalizer.normalize("전화", data.cell(i, 8))
      user.email = normalizer.normalize("메일", data.cell(i, 9))
      user.habitat_id = data.cell(i, 10)
      user.member_type = data.cell(i, 11)
      user.password = "testtest"

      if user.has_invalid_column?
        @invalid_users.push(user)
        @invalid_ids.push(i)
      else
        user.save!
      end
    end

    if @invalid_users.count == 0
      flash[:notice] = "멤버 입력을 성공 했습니다."
      redirect_to admin_users_path 
    else
      flash[:notice] = "대부분의 멤버들은 입력을 성공했습니다. 하지만 몇몇 멤버들은 실패했습니다. "
      render 'new'
    end

  end
end
