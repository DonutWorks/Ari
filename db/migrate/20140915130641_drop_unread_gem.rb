require_relative './20140903123131_unread_migration.rb'

class DropUnreadGem < ActiveRecord::Migration
  def self.up
    # Irreversible
    UnreadMigration.down
  end

  def self.down
    UnreadMigration.up
  end
end