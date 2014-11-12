class ActivityHasManyExpenseRecords < ActiveRecord::Migration
  def change
    add_reference :expense_records, :activity, index: true
    add_reference :expense_records, :notice, index: true
  end
end
