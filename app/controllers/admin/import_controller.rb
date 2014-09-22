class Admin::ImportController < Admin::ApplicationController

  def new
    @invalid_users = []
    @invalid_ids = []
  end

  def create
    data = ExcelImporter.import(params[:upload][:file])

    @invalid_users = []
    @invalid_ids = []
    normalizer = FormNormalizer.new

    (2..data.last_row).each do |i|
      user = UserModelNormalizer.normalize(normalizer, data, i)

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
