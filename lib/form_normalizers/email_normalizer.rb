module FormNormalizers
  class EmailNormalizer < Normalizer
    def column_names
      @column_names ||= ["메일", "이메일", "이메일주소"]
    end

    def normalize(term)
      raise NormalizeError, "Email이 비어 있습니다." if term.blank?
      term.delete!(" ")
      return term if term.include?("@")
      raise NormalizeError, "Email이 형식에 맞지 않습니다. (#{term})"
    end
  end
end