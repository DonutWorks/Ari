class CreateAccountAndExpenseRecord < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :account_number
      t.timestamps
    end

    create_table :expense_records do |t|
      t.datetime :record_date
      t.integer :deposit
      t.integer :withdraw
      t.string :content
      t.boolean :confirm
      t.references :account, index: true
      t.timestamps
    end
  end
end
