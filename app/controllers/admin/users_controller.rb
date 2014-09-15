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
      flash[:notice] = @user.username + "님의 회원 정보 수정에 성공했습니다"
      redirect_to admin_users_index_path
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    flash[:notice] = @user.username + "님의 회원 정보 삭제에 성공했습니다"
    @user.destroy

    redirect_to admin_users_index_path
  end

private
  def user_params
    params.require(:user).permit(:username, :email, :phonenumber, :major)
  end

end
