module FormNormalizers
  class NormalizeError < RuntimeError
  end

  class Normalizer
    def column_names
      raise 'This method should be overriden and return related column names.'
    end

    def normalize(term)
      term
    end
  end
end