class MoveProviderTokenInfoToNewModel < ActiveRecord::Migration
	class AccountActivation < ActiveRecord::Base
	end

	class ProviderToken < ActiveRecord::Base
	end

  def up
  	AccountActivation.all.each do |activation|
  		ProviderToken.create!(account_activation_id: activation.id, uid: activation.uid, provider: activation.provider)
  	end

  	remove_column :account_activations, :provider
  	remove_column :account_activations, :uid
  end

  def down
  	add_column :account_activations, :provider, :string
  	add_column :account_activations, :uid, :string

  	AccountActivation.all.each do |activation|
  		token = ProviderToken.find_by_account_activation_id(activation.id)
  		activation.update_attributes!(uid: token.uid, provider: token.provider)
  	end

  	ProviderToken.destroy_all
  end
end
