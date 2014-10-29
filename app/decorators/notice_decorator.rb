class NoticeDecorator < Draper::Decorator
  delegate_all

  def pretty_created_at
    created_at.localtime.strftime("%Y-%m-%d %T")
  end

  def survey_due_date
    (due_date - 3.days).localtime.strftime("%Y-%m-%d %T")
  end

end
