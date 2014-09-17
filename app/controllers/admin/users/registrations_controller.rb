class Admin::Users::RegistrationsController < Admin::ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params.merge(password: "testtest"))

    if @user.save
      flash[:notice] = params[:user][:username] + "님 회원 등록 완료"
      redirect_to admin_users_path
    else
      flash[:alert] = "정보가 유효하지 않습니다. 다시 확인해주세요."
      render "new"
    end
  end

private
  def user_params
    params.require(:user).permit(:username, :email, :phone_number, :major)
  end
end