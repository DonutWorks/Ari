module FormNormalizers
  class EmailNormalizer < Normalizer
    def column_names
      @column_names ||= ["메일", "이메일", "이메일주소"]
    end

    def normalize(term)
      if term.blank?
        return "Invalid"
      else
        term.delete!(" ")
      end
      return term if term.include?("@")
      raise NormalizeError, "Email이 형식에 맞지 않습니다. (#{term})"
    end
  end
end