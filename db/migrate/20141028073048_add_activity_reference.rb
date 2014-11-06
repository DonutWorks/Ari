class AddActivityReference < ActiveRecord::Migration
  def change
    add_reference :notices, :activity, index: true
  end
end
