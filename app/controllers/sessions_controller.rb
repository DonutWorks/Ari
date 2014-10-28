class SessionsController < AuthenticatableController
  skip_before_action :require_activated

  def new
    @user = User.new
  end

  # log in with phone number
  def create
    phone_number = params[:user][:phone_number]
    remember_me = params[:user][:remember_me] == "1"

    out = Authenticates::PhoneNumberSignInService.new(current_club).execute(session, phone_number)

    case out[:status]
    when :invalid_phone_number
      flash[:error] = "전화번호가 잘못되었습니다."
      redirect_to club_sign_in_path(current_club)
    when :success
      Authenticates::UserCookies.new(cookies).create!(out[:user], true) if remember_me
      proceed
    end
  end

  def auth_without_club
    @user = User.new(user_params)

    out = Authenticates::FetchJoinedClubService.new.execute(@user.phone_number)

    case out[:status]
    when :invalid_phone_number
      flash[:error] = "전화번호가 잘못되었습니다."
      redirect_to sign_in_path
    when :success
      @joined_clubs = out[:clubs]
      render 'clubs'
    end
  end

  def destroy
    Authenticates::UserSession.new(session).destroy!
    Authenticates::UserCookies.new(cookies).destroy!
    proceed
  end

private
  def user_params
    params.require(:user).permit(:phone_number, :remember_me)
  end
end