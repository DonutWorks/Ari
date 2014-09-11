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

    normalizer = @normalizers.detect do |normalizer|
      normalizer.column_names.include?(column_name)
    end

    normalizer || FormNormalizers::Normalizer
  end
end