class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :require_no_authentication, only: [:new, :create]
  
  def new
    @user = User.new
  end

  def create

    User.create!(user_params.merge(password: "testtest"))

    flash[:notice] = params[:user][:username] + "님 회원 등록 완료"
    redirect_to admin_root_path
  end

private
  def user_params
    params.require(:user).permit(:username, :email, :phonenumber, :major)
  end
end
