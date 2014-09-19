class SessionsController < ApplicationController
  skip_before_action :authenticated?, :only => [:new, :create]

  def new
    @user = User.new
  end

  def create
    phone_number = params[:user][:phone_number]
    if @user = User.find_by_phone_number(phone_number)
      session[:user_id] = @user.id
      redirect_to session[:referer] || session_path(@user)
    else
      flash[:alert] = "등록되지 않은 전화번호 입니다"
      redirect_to new_session_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path
  end

  def show
    @user = current_user
  end
end
