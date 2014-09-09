class FormNormalizer
  MALE_GROUP = %w(남 남자)
  FEMALE_GROUP = %w(여 여자)
  def self.normalize_gender(term)
    term = term.delete(" ")
    return "남" if MALE_GROUP.include?(term)
    return "여" if FEMALE_GROUP.include?(term)
    return term
  end

  def self.normalize_phone_number(term)
    begin
      Phoner::Phone.parse(term, country_code: "82").format("%A%f%l")
    rescue
      term
    end
  end
end