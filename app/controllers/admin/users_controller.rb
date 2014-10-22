class Admin::UsersController < Admin::ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "\"#{@user.username}\"님의 회원 정보 생성에 성공했습니다."
      redirect_to club_admin_users_path(current_club)
    else
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:notice] = "\"#{@user.username}\"님의 회원 정보 수정에 성공했습니다."
      redirect_to club_admin_user_path(current_club, @user)
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    flash[:notice] = "\"#{@user.username}\"님의 회원 정보 삭제에 성공했습니다."
    redirect_to club_admin_users_path(current_club)
  end

  def show
    @user = User.find(params[:id])
  end


private
  def user_params
    params.require(:user).permit(:username, :email, :phone_number, :major, :student_id, :sex, :home_phone_number, :emergency_phone_number, :habitat_id, :member_type, :generation_id, :birth)
  end
end