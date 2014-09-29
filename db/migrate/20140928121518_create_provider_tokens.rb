class CreateProviderTokens < ActiveRecord::Migration
  def change
    create_table :provider_tokens do |t|
    	t.string :provider
    	t.string :uid
    	t.text :info

      t.timestamps
    end
  end
end
