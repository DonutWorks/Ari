class Admin::ImportController < Admin::ApplicationController

  def new
    @invalid_users = []
    @invalid_ids = []
  end

  def create
    @invalid_users = []
    @invalid_ids = []

    if !params[:upload].blank?
      data = ExcelImporter.import(params[:upload][:file])
      data.default_sheet = data.sheets.first

      lastRow = data.last_row
      lastColumn = data.last_column

      normalizer = FormNormalizer.new

      (2..lastRow).each do |i|
        user = UserModelNormalizer.normalize(normalizer, data, i)

        if user.has_invalid_column?
          @invalid_users.push(user)
          @invalid_ids.push(i)
        else
          user_already = User.find_by_phone_number(user.phone_number)
          if user_already.blank?
            user.save!
          else
            user_already.update_attributes(user.as_json(except: [:id]))
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
    else
      flash[:notice] = "첨부파일을 업로드 하세요. "
      render 'new'
    end
  end
end
