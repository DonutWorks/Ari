class SessionsController < AuthenticatableController
  skip_before_action :require_activated

  def new
    disable_footer

    # need to fix current_club.users.new?
    @user = User.new
    if current_club
      @action = club_auth_path(current_club)
    else
      @action = auth_path
    end
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
      remember_user(remember_me, out[:user])
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

      if @joined_clubs.count == 1
        signing_club = @joined_clubs.first

        out = Authenticates::PhoneNumberSignInService.new(signing_club).execute(session, @user.phone_number)
        remember_user(@user.remember_me == "1", out[:user])
        redirect_to club_path(signing_club)
        return
      end

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

  def remember_user(remember_me, user)
    Authenticates::UserCookies.new(cookies).create!(user, true) if remember_me
  end
end