class Admin::SessionsController < Devise::SessionsController
	def new
		disable_footer
		super
	end
end