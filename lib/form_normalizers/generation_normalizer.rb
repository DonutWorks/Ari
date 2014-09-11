module FormNormalizers
  class GenerationNormalizer < Normalizer
    def self.column_names
      @column_names ||= ["기수", "기"]
    end

    def self.normalize(term)
      return term if term.end_with?("기")
      return term << "기" if is_numeric?(term)
      raise NormalizeError
    end

  private
    def self.is_numeric?(term)
      Float(term) != nil rescue false
    end
  end
end