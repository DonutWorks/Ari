class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :require_no_authentication, only: [:new, :create]
  
  def new
    @user = User.new
  end

  def create
    User.create!(
      username: params[:user][:username],
      email: params[:user][:email],
      phonenumber: params[:user][:phonenumber],
      major: params[:user][:major],
      password: "testtest")

    flash[:notice] = params[:user][:username] + "님 회원 등록 완료"
    redirect_to admin_index_path
  end
end
