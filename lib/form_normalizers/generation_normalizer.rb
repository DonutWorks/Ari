module FormNormalizers
  class GenerationNormalizer < Normalizer
    def column_names
      @column_names ||= ["기수", "기"]
    end

    def normalize(term)
      return term if term.end_with?("기")
      return term << "기" if is_numeric?(term)
      return "Invalid"
      #raise NormalizeError, "Invalid generation string: #{term}"
    end

  private
    def is_numeric?(term)
      Float(term) != nil rescue false
    end
  end
end