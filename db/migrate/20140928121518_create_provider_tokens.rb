class CreateProviderTokens < ActiveRecord::Migration
  def change
    create_table :provider_tokens do |t|
    	t.string :provider
    	t.string :uid
    	t.text :info
      t.references :account_activation, index: true

      t.timestamps
    end
  end
end
