class SessionsController < AuthenticatableController
  skip_before_action :authenticate!, except: [:new]

  def new
    @user = User.new
  end

  # log in with phone number
  def create
    normalizer = FormNormalizers::PhoneNumberNormalizer.new
    phone_number = normalizer.normalize(params[:user][:phone_number])
    remember_me = params[:user][:remember_me] == "1"

    user = User.find_by_phone_number(phone_number)
    if user.nil?
      flash[:error] = "전화번호가 잘못되었습니다."
      redirect_to sign_in_users_path
      return
    end

    session[:user_id] = user.id
    authenticate!(remember_me: remember_me)

  rescue FormNormalizers::NormalizeError => e
    flash[:error] = "전화번호가 잘못되었습니다."
    redirect_to sign_in_users_path
  end

  def destroy
    session.delete(:user_id)
    clear_sign_in_cookie!
    redirect_to sign_in_users_path
  end
end