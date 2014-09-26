class ProvidersController < AuthenticatableController
	skip_before_action :authenticate_user!
	before_action :require_auth_hash

	def create
		authenticate!
	end

private
  def authenticate!
  # extendable?
    activation = AccountActivation.find_by(provider: auth_hash['provider'],
     uid: auth_hash['uid'])

    if activation && activation.activated
      session[:user_id] = activation.user.id
      redirect_to session.delete(:return_to) || root_path
    else
      redirect_to new_activation_path
    end
  end
end