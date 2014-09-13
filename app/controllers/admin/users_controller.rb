class Admin::UsersController < Admin::ApplicationController
  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:user][:id])
 
    if @user.update(user_params)
      redirect_to admin_users_index_path
    else
      flash[:alert] = "정보가 유효하지 않습니다. 다시 확인해 주세요."
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to admin_users_index_path
  end

private
  def user_params
    params.require(:user).permit(:username, :email, :phonenumber, :major)
  end

end
