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
      is_invalid = false

      d = normalizer.normalize("기수", data.cell(i, 1))
      if d == "Invalid"
        is_invalid = true
      else
        user.group_id = d
      end

      user.major = data.cell(i, 2)
      user.student_id = data.cell(i, 3)
      user.sex = normalizer.normalize("성별", data.cell(i, 4))
      user.username = data.cell(i, 5)

      d = normalizer.normalize("전화", data.cell(i, 6))
      if d == "Invalid"
        is_invalid = true
      else
        user.home_phone_number = d
      end

      d = normalizer.normalize("전화", data.cell(i, 7))
      if d == "Invalid"
        is_invalid = true
      else
        user.phone_number = d
      end

      d = normalizer.normalize("전화", data.cell(i, 8))
      if d == "Invalid"
        is_invalid = true
      else
        user.emergency_phone_number = d
      end

      d = normalizer.normalize("메일", data.cell(i, 9))
      if d == "Invalid"
        is_invalid = true
      else
        user.email = d
      end

      user.habitat_id = data.cell(i, 10)
      user.member_type = data.cell(i, 11)
      user.password = "testtest"

      if is_invalid
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
