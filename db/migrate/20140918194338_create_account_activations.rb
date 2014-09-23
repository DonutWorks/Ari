class CreateAccountActivations < ActiveRecord::Migration
  def change
    create_table :account_activations do |t|
      t.references :user, index: true
      t.boolean :activated
      t.string :provider
      t.string :uid

      t.timestamps
    end
  end
end
