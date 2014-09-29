module FormNormalizers
  class BirthNormalizer < Normalizer
    def column_names
      @column_names ||= ["생일","생년월일"]
    end

    def normalize(term)
      term = term.to_i
      term = term.to_s unless term.blank?
      return term
      raise NormalizeError, "생년월일이 형식에 맞지 않습니다. (#{term})"
    end
  end
end