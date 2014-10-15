class ChangeReadableTypeGateNotice < ActiveRecord::Migration
  class ReadActivityMark < ActiveRecord::Base
  end

  def up
    ReadActivityMark.update_all(readable_type: "Notice")
  end

  def down
    ReadActivityMark.update_all(readable_type: "Gate")
  end
end
