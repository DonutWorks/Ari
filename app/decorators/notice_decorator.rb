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

  def raw_notice_type
    object.notice_type
  end

  def notice_type
    case object.notice_type
    when "to"
      status = "참가조사"
    when "checklist"
      status = "할일 배분"
    when "external"
      status = "외부공지"
    when "plain"
      status = "텍스트 공지"
    when "survey"
      status = "수요조사"
    end
  end
end
