class FormNormalizer
  @normalizers = [
    FormNormalizers::GenderNormalizer,
    FormNormalizers::PhoneNumberNormalizer,
    FormNormalizers::GenerationNormalizer
  ]

  def self.normalize(column_name, term)
    find_normalizer(column_name).send(:normalize, term)
  end

private
  def self.find_normalizer(column_name)
    column_name.delete!(" ")
    @normalizers.each do |normalizer|
      if normalizer.send(:column_names).include?(column_name)
        return normalizer
      end
    end
    return FormNormalizers::Normalizer
  end
end