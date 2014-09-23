class Admin::ImportController < Admin::ApplicationController

  def new
    @invalid_messages = []
  end

  def create
    @invalid_messages = []
      
    if !params[:upload].blank?
      file = Tempfile.new(['data','.xlsx'])
      file.binmode
      file.write(params[:upload][:file].read)

      data = Roo::Excelx.new(file.path)
      data.default_sheet = data.sheets.first

      lastRow = data.last_row
      lastColumn = data.last_column

      normalizer = FormNormalizer.new

      (2..lastRow).each do |i|
        user = User.new

        begin
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
        rescue FormNormalizers::NormalizeError => e
          messages = i.to_s + "열의 " + user.username + "은(는) " + e.message
          @invalid_messages.push(messages)
        else
          user.save!
        end

      end

      if @invalid_messages.count == 0
        flash[:notice] = "멤버 입력을 성공 했습니다."
        redirect_to admin_users_path 
      else
        flash[:notice] = "대부분의 멤버들은 입력을 성공했습니다. 하지만 몇몇 멤버들은 실패했습니다. "
        render 'new'
      end
    else
      flash[:notice] = "첨부파일을 업로드 하세요. "
      render 'new'
    end

  end
end
