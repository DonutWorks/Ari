class NoticeDecorator < Draper::Decorator
  delegate_all

  def created_at
    object.created_at.localtime.strftime("%Y-%m-%d %T")
  end

  def due_date
    object.due_date.localtime.strftime("%Y-%m-%d %T")
  end

  def event_at
    object.event_at.localtime.strftime("%Y-%m-%d %T")
  end

  def raw_due_date
    object.due_date
  end

  def event_at
    object.event_at.localtime.strftime("%Y-%m-%d %T")
  end

  def content
    h.simple_format(object.content)
  end

  def notice_type
    case object.notice_type
    when "to"
      status = "TO조사"
    when "checklist"
      status = "체크리스트"
    when "external"
      status = "외부공지"
    when "internal"
      status = "내부공지"
    when "survey"
      status = "수요조"
    end
  end
end
