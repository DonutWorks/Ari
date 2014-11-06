module FormNormalizers
  class PhoneNumberNormalizer < Normalizer
    def column_names
      @column_names ||= ["휴대전화", "휴대폰번호", "전화번호", "휴대폰", "폰번호", "폰", "휴대전화번호", "본인연락처"]
    end

    def normalize(term)
      Phoner::Phone.parse(term, country_code: "82").format("%A%f%l")
    rescue => e
      if term != "없음"
        raise NormalizeError, "전화번호가 형식에 맞지 않습니다. (#{term})"
      end
      term
    end
  end
end