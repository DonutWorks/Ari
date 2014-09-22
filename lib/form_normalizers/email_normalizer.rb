module FormNormalizers
  class EmailNormalizer < Normalizer
    def column_names
      @column_names ||= ["메일", "이메일", "이메일주소"]
    end

    def normalize(term)
      term.delete!(" ")
      return term if term.include?("@")
      raise NormalizeError, "Invalid Email string: #{term}"
    end
  end
end