module Admin::ExpenseRecordsHelper
  #should be moved to Decorator
  def link_response(record)
    if record.response
      response = record.response
      notice = response.notice
      activity = notice.activity
      user = response.user

      link_to club_admin_notice_path(notice.club, notice) do
        user.username + " (" + notice.title + " - " + activity.title + ")"
      end
    end
  end
end
