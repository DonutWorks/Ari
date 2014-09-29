class Admin::ImportController < Admin::ApplicationController

  def new
    @invalid_messages = []
  end

  def create
    @invalid_messages = []

    if !params[:upload].blank?
      data = ExcelImporter.import(params[:upload][:file])
      data.default_sheet = data.sheets.second

      normalizer = FormNormalizer.new

      (2..data.last_row).each do |i|
        begin
          user = UserModelNormalizer.normalize(normalizer, data, i)
        rescue UserModelNormalizer::NormalizeError => e
          messages = i.to_s + "행(" + (e.user.username||="알수없음") + "님)은 " + e.message
          @invalid_messages.push(messages)
        else
          user_already = User.find_by_phone_number(user.phone_number)
          if user_already.blank?
            unless user.save
              messages = i.to_s + "행(" + (user.username||="알수없음") + "님)은 꼭 필요한 데이터를 입력하지 않았습니다. "
              @invalid_messages.push(messages)
            end
          else
            user_already.update_attributes(user.as_json(except: [:id]))
          end
        end
      end

      if @invalid_messages.count == 0
        flash[:notice] = "멤버 입력에 성공했습니다."
        redirect_to admin_users_path
      else
        @error_message = "대부분의 멤버들은 입력에 성공했습니다. 하지만 몇몇 멤버들은 실패했습니다."
        render 'new'
      end
    else
      @error_message = "첨부파일을 업로드 하세요."
      render 'new'
    end
  end



end
