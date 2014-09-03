class Users::RegistrationsController < Devise::RegistrationsController

  def create
    User.create!(
      username: params[:user][:username],
      password: "testtest")

    flash[:notice] = params[:user][:username] + "님 회원 등록 완료"
    redirect_to admin_index_path
  end
end
