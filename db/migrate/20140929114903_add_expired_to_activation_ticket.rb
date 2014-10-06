class AddExpiredToActivationTicket < ActiveRecord::Migration
  def change
  	add_column :activation_tickets, :expired, :boolean, default: false
  end
end
