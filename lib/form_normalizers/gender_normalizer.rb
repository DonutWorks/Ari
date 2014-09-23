module FormNormalizers
  class GenderNormalizer < Normalizer
    MALE_GROUP = %w(남 남자)
    FEMALE_GROUP = %w(여 여자)

    def column_names
      @column_names ||= ["성별"]
    end

    def normalize(term)
      return "" if term.blank?
      term.delete!(" ")
      return "남" if MALE_GROUP.include?(term)
      return "여" if FEMALE_GROUP.include?(term)
      raise NormalizeError, "성별이 형식에 맞지 않습니다. (#{term})"
    end
  end
end