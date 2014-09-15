class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :require_no_authentication, only: [:new, :create]
  
  def new
    @user = User.new
  end

  def create

    user = User.new(user_params.merge(password: "testtest"))

    if user.save
      flash[:notice] = params[:user][:username] + "님 회원 등록 완료"
      redirect_to admin_root_path
    else
      flash[:alert] = "정보가 유효하지 않습니다. 다시 확인해주세요."
      redirect_to new_user_registration_path
    end

    
  end

private
  def user_params
    params.require(:user).permit(:username, :email, :phone_number, :major)
  end
end
