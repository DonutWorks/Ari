module Admin::ExpenseRecordsHelper
  def link_response(record)
    if record.response
      response = record.response
      notice = response.notice
      activity = notice.activity
      user = response.user

      "자"
      link_to admin_notice_path(notice) do
        user.username + " (" + notice.title + " - " + activity.title + ")"
      end
    end
  end
end
