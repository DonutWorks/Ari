class AddEventedAtColumnToNotice < ActiveRecord::Migration
  class Notice < ActiveRecord::Base
  end

  def up
    add_column :notices, :event_at, :datetime

    Notice.reset_column_information
    Notice.all.each do |notice|
      notice.update_attributes!(event_at: notice.due_date, due_date: notice.due_date - 3.days)
    end
  end

  def down
    Notice.reset_column_information
    Notice.all.each do |notice|
      notice.update_attributes!(event_at: nil, due_date: notice.event_at)
    end
  end
end
