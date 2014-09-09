module FormNormalizers
  class Normalizer
    def self.normalize(term)
      term
    end

    def self.column_names
      raise 'This method should be overriden and return related column names.'
    end
  end
end