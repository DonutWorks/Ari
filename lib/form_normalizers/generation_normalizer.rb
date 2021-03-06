module FormNormalizers
  class GenerationNormalizer < Normalizer
    def column_names
      @column_names ||= ["기수", "기"]
    end

    def normalize(term)
      raise NormalizeError, "기수가 비어 있습니다." if term.blank?
      term.delete!(" ")
      term.delete!("기")
      return term

      raise NormalizeError, "기수가 형식에 맞지 않습니다. (#{term})"
    end

  private
    def is_numeric?(term)
      Float(term) != nil rescue false
    end
  end
end