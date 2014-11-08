class NoticeDecorator < Draper::Decorator
  delegate_all

  def created_at
    object.created_at.localtime.strftime("%Y-%m-%d %T")
  end

  def due_date
    object.due_date.localtime.strftime("%Y-%m-%d %T")
  end

  def raw_due_date
    object.due_date
  end

  def survey_due_date
    (object.due_date - 3.days).localtime.strftime("%Y-%m-%d %T")
  end

  def content
    h.simple_format(object.content)
  end
end
