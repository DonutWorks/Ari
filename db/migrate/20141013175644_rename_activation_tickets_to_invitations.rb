class RenameActivationTicketsToInvitations < ActiveRecord::Migration
  def change
    rename_table :activation_tickets, :invitations
  end
end
