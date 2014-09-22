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

      user.group_id = normalizer.normalize(data.cell(1, 1), data.cell(i, 1))
      user.major = data.cell(i, 2)
      user.student_id = data.cell(i, 3)
      user.sex = normalizer.normalize(data.cell(1, 4), data.cell(i, 4))
      user.username = data.cell(i, 5)
      user.home_phone_number = normalizer.normalize(data.cell(1, 6), data.cell(i, 6))
      user.phone_number = normalizer.normalize(data.cell(1, 7), data.cell(i, 7))
      user.emergency_phone_number = normalizer.normalize(data.cell(1, 8), data.cell(i, 8))
      user.email = normalizer.normalize(data.cell(1, 9), data.cell(i, 9))
      user.habitat_id = data.cell(i, 10)
      user.member_type = data.cell(i, 11)

      if user.has_invalid_column?
        @invalid_users.push(user)
        @invalid_ids.push(i)
      else
        user.save!
        user_already = User.find_by_phone_number(user.phone_number)
        if user_already != nil
          user_already.update_attributes(user.as_json(except: [:id]))
        else
          user.save!
        end
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
