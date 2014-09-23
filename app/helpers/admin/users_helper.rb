module Admin::UsersHelper
  def pretty_phone_number(phone_number)
    return nil unless phone_number

    if (phone_number.length == 10 || phone_number.length == 11) && phone_number.count("-") != 2
      phone_number.insert(3, '-').insert(-5, '-')
    end

    phone_number
  end

  def pretty_generation_id(generation_id)
    generation_id.to_s.gsub(".0", "") + " 기" if generation_id
  end
end
