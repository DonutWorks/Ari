class SetAccountActivationsActivatedDefaultFalse < ActiveRecord::Migration
  def change
    change_column_default :account_activations, :activated, false
  end
end
