module Admin::UsersHelper
  def pretty_phone_number(phone_number)
    if (phone_number.length == 10 || phone_number.length == 11) && phone_number.count("-") != 2
      phone_number.insert(3, '-').insert(-5, '-')
    end
    
    phone_number
  end
end
