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

  def event_at
    object.event_at.localtime.strftime("%Y-%m-%d %T")
  end

end
