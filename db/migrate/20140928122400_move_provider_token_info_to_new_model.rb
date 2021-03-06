class MoveProviderTokenInfoToNewModel < ActiveRecord::Migration
	class AccountActivation < ActiveRecord::Base
    has_one :provider_token
	end

	class ProviderToken < ActiveRecord::Base
	end

  def up
    add_column :account_activations, :provider_token_id, :integer

  	AccountActivation.all.each do |activation|
  		token = ProviderToken.create!(uid: activation.uid, provider: activation.provider)
      activation.update_attributes(provider_token_id: token.id)
    end

  	remove_column :account_activations, :provider
  	remove_column :account_activations, :uid
  end

  def down
  	add_column :account_activations, :provider, :string
  	add_column :account_activations, :uid, :string
    add_index :account_activations, [:provider, :uid]

  	AccountActivation.all.each do |activation|
  		token = ProviderToken.find_by_id(activation.provider_token_id)
  		activation.update_attributes!(uid: token.uid, provider: token.provider)
  	end

    remove_column :account_activations, :provider_token_id

  	ProviderToken.destroy_all
  end
end
