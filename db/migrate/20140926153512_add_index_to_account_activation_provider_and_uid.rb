class AddIndexToAccountActivationProviderAndUid < ActiveRecord::Migration
  def change
  	add_index :account_activations, [:provider, :uid]
  end
end
