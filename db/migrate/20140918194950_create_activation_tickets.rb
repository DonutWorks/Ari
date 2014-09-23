class CreateActivationTickets < ActiveRecord::Migration
  def change
    create_table :activation_tickets do |t|
      t.string :code
      t.references :account_activation, index: true

      t.timestamps
    end
  end
end
