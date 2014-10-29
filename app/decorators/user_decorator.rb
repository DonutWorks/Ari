class UserDecorator < Draper::Decorator
  delegate_all


  PHONE_TYPES = %w(phone_number home_phone_number emergency_phone_number )
  PHONE_TYPES.each do |number_type|

    define_method("pretty_#{number_type}") do
      number = attributes[number_type]
      return nil unless number

      if (number.length == 10 || number.length == 11) and number.count("-") != 2
        number.insert(3, '-').insert(-5, '-')
      end

      number
    end
  end


  def pretty_generation
    generation_id.to_s.gsub(".0", "") + " 기" if generation_id
  end

  def pretty_tags
    tags.map { |tag| '#'+"#{tag.tag_name}" }.join(" ")
  end

  def pretty_read_at(notice)
    if read_at(notice)
      read_at(notice).localtime.strftime("%Y-%m-%d %T")
    else
      '-'
    end
  end


end
