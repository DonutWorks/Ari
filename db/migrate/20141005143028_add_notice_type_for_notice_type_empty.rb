class AddNoticeTypeForNoticeTypeEmpty < ActiveRecord::Migration
  class Notice < ActiveRecord::Base
  end

  def up
    Notice.reset_column_information
    Notice.all.each do |notice|
      if notice.notice_type.blank?
        notice.update_attributes!(notice_type: "external")
      end
    end
  end

  def down
    # nothing to do
  end
end
