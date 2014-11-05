class MessageDecorator < Draper::Decorator
  delegate_all
  decorates_association :users, scope: :order_by_gid


  def created_at
    object.created_at.localtime.strftime("%Y-%m-%d %T")
  end

end
