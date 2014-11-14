class BackfillPublicActivity < ActiveRecord::Migration
  def up
    Response.find_each do |response|
      response.create_activity(:create) if response.notice
    end

    Checklist.find_each do |checklist|
      if checklist.notice
        checklist.create_activity(:create)
        checklist.create_activity(:finish, owner: checklist.assignees.first) if checklist.finish
      end
    end

    AssigneeComment.find_each do |comment|
      comment.create_activity(:create) if comment.checklist and comment.checklist.notice
    end
  end

  def down
    PublicActivity::Activity.delete_all
  end
end
