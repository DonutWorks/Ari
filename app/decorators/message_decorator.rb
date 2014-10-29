class MessageDecorator < Draper::Decorator
  delegate_all


  def pretty_created_at
    created_at.localtime.strftime("%Y-%m-%d %T")
  end

end
