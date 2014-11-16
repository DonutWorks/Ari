class UserDecorator < Draper::Decorator
  delegate_all


  PHONE_TYPES = %w(phone_number home_phone_number emergency_phone_number )
  PHONE_TYPES.each do |number_type|

    define_method("#{number_type}") do
      number = object.attributes[number_type]
      return nil unless number

      if (number.length == 10 || number.length == 11) and number.count("-") != 2
        number.insert(3, '-').insert(-5, '-')
      end

      number
    end
  end


  def generation_id
    object.generation_id.to_s.gsub(".0", "") + " 기" if object.generation_id
  end

  def tags
    return nil if object.tags.empty?
    return object.tags.map { |tag| '#'+"#{tag.tag_name}" }.join(" ")
  end

  def read_at(notice)
    if object.read_at(notice)
      object.read_at(notice).localtime.strftime("%Y-%m-%d %T")
    else
      '-'
    end
  end


end
