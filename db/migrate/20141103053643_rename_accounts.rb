class RenameAccounts < ActiveRecord::Migration
  def change
    remove_reference :expense_records, :account, index: true
    rename_table :accounts, :bank_accounts 
    add_reference :expense_records, :bank_account, index: true
  end
end
