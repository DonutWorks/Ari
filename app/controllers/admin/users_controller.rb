class Admin::UsersController < Admin::ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)


    @user.transaction do
      begin
        associate_user_with_user_tags!
        @user.save!
        flash[:notice] = "\"#{@user.username}\"님의 회원 정보 생성에 성공했습니다."
        redirect_to admin_users_path
      rescue
        render "new"
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    @user.transaction do
      begin
        associate_user_with_user_tags!
        @user.update!(user_params)
        flash[:notice] = "\"#{@user.username}\"님의 회원 정보 수정에 성공했습니다."
        redirect_to admin_user_path(@user)
      rescue
        render 'edit'
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    flash[:notice] = "\"#{@user.username}\"님의 회원 정보 삭제에 성공했습니다."
    redirect_to admin_users_path
  end

  def show
    @user = User.find(params[:id])
  end


private
  def user_params
    params.require(:user).permit(:username, :email, :phone_number, :major, :student_id, :sex, :home_phone_number, :emergency_phone_number, :habitat_id, :member_type, :generation_id, :birth)
  end

  def associate_user_with_user_tags!
    referenced_tags = extract_tags(@user, params[:tags])

    @user.tags.destroy_all

    referenced_tags.each do |tag|
      @user.user_user_tags.build(user_tag_id: tag.id)
    end if referenced_tags != nil
  end

  def extract_tags(user, content)
    pattern = /(\w+);/

    referenced = content.scan(pattern)

    referenced.flatten!.map! do |term|

      UserTag.find_by_tag_name(term)

    end if !referenced.empty?

  end

end