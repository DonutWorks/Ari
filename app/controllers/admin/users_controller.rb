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
      flash[:notice] = params[:user][:username] + "님 회원 등록 완료"
      redirect_to admin_users_path
    else
      flash[:alert] = "정보가 유효하지 않습니다. 다시 확인해주세요."
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:notice] = @user.username + "님의 회원 정보 수정에 성공했습니다"
      redirect_to admin_user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    flash[:notice] = @user.username + "님의 회원 정보 삭제에 성공했습니다"
    @user.destroy

    redirect_to admin_users_path
  end

  def show
    @user = User.find(params[:id])
  end


private
  def user_params
    params.require(:user).permit(:username, :email, :phone_number, :major)
  end

end
