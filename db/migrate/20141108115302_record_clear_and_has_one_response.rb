class RecordClearAndHasOneResponse < ActiveRecord::Migration
  def change
    remove_reference :expense_records, :activity, index: true
    remove_reference :expense_records, :notice, index: true

    add_reference :responses, :expense_record, index: true
  end
end
