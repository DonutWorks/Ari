class ActivityDecorator < Draper::Decorator
  delegate_all

  def event_at
    object.event_at.localtime.strftime("%Y-%m-%d %T")
  end

end
