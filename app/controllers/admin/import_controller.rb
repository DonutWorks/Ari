class Admin::ImportController < Admin::ApplicationController
  def new
    @invalid_messages = []
  end

  def create
    @invalid_messages = []

    if !params[:upload].blank?
      data = ExcelImporter.import(params[:upload][:file])
      data.default_sheet = data.sheets.first

      normalizer = FormNormalizer.new

      (2..data.last_row).each do |i|
        begin
          user = UserModelNormalizer.normalize(normalizer, data, i)
        rescue UserModelNormalizer::NormalizeError => e
          messages = i.to_s + "행(" + (e.user.username||="알수없음") + "님)은 " + e.message
          @invalid_messages.push(messages)
        else
          new_user = current_club.users.find_or_initialize_by(phone_number: user.phone_number)
          new_user.attributes = user.as_json(except: [:id]).merge(club: current_club)

          if new_user.valid?
            associate_user_with_tags!(new_user)
            new_user.save
          else
            @invalid_messages.push(new_user.errors.inspect)
            messages = i.to_s + "행(" + (new_user.username||="알수없음") + "님)은 꼭 필요한 데이터를 입력하지 않았습니다. "
            @invalid_messages.push(messages)
          end
        end
      end

      if @invalid_messages.count == 0
        flash[:notice] = "멤버 입력에 성공했습니다."
        redirect_to club_admin_users_path(current_club)
      else
        @error_message = "대부분의 멤버들은 입력에 성공했습니다. 하지만 몇몇 멤버들은 실패했습니다."
        render 'new'
      end
    else
      @error_message = "첨부파일을 업로드 하세요."
      render 'new'
    end
  end

private

  def associate_user_with_tags!(user)
    terms = [user.major, "#{user.generation_id.to_s.gsub(".0", "") + "기" if user.generation_id}", user.member_type]

    terms.map! do |term|
      next if term.blank?
      term.strip!
      begin
        tag = current_club.tags.find_or_create_by(tag_name: term.to_s.force_encoding(Encoding::UTF_8))
      rescue Encoding::CompatibilityError => e
        raise term.to_s.force_encoding(Encoding::UTF_8)
      end
    end if !terms.empty?
    user.tags.destroy_all

    terms.compact.each do |tag|
      user.taggings.build(tag_id: tag.id)
    end if !terms.empty?

  end

end

