class SessionsController < AuthenticatableController
  skip_before_action :authenticate_user!

  def new
    @user = User.new
  end

  # log in with phone number
  def create
    normalizer = FormNormalizers::PhoneNumberNormalizer.new
    phone_number = normalizer.normalize(params[:user][:phone_number])

    user = User.find_by_phone_number(phone_number)
    if user.nil?
      redirect_to sign_in_users_path
      return
    end

    session[:user_id] = user.id
    redirect_to session.delete(:return_to) || root_path

  rescue FormNormalizers::NormalizeError => e
    redirect_to sign_in_users_path
  end

  def destroy
    session.delete(:user_id)
    redirect_to sign_in_users_path
  end
end