class AddClubToClubRelatedModel < ActiveRecord::Migration
  def change
    add_reference :admin_users, :club, index: true
    add_reference :users, :club, index: true
    add_reference :messages, :club, index: true
    add_reference :notices, :club, index: true
    add_reference :responses, :club, index: true
    add_reference :invitations, :club, index: true
  end
end
