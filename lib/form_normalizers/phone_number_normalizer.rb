module FormNormalizers
  class PhoneNumberNormalizer < Normalizer
    def column_names
      @column_names ||= ["휴대전화", "휴대폰번호", "전화번호", "휴대폰", "폰번호", "폰", "전화"]
    end

    def normalize(term)
      begin
        Phoner::Phone.parse(term, country_code: "82").format("%A%f%l")
      rescue => e
        raise NormalizeError, "Invalid phone number string: #{term}"
      end
    end
  end
end