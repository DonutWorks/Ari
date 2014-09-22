class User < ActiveRecord::Base
  validates_presence_of :username, :phone_number
  validates_uniqueness_of :phone_number

  before_save :normalize_phone_number

  acts_as_reader

  def has_invalid_column?
    has_invalid = false
    self.attributes.each do |attr_name, attr_value|
      if attr_value == "Invalid"
        has_invalid = true
        break
      end
    end
    has_invalid
  end

private
  def normalize_phone_number
    normalizer = FormNormalizers::PhoneNumberNormalizer.new
    self.phone_number = normalizer.normalize(phone_number)
  end


end
