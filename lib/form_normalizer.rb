class FormNormalizer
  NORMALIZERS = [
    FormNormalizers::GenderNormalizer,
    FormNormalizers::PhoneNumberNormalizer,
    FormNormalizers::GenerationNormalizer,
    FormNormalizers::EmailNormalizer
  ]

  def initialize
    @normalizers = NORMALIZERS.map do |normalizer|
      normalizer.new
    end
    @default_normalizer = FormNormalizers::Normalizer.new
  end

  def normalize(column_name, term)
    find_normalizer(column_name).send(:normalize, term)
  end

private
  def find_normalizer(column_name)
    column_name.delete!(" ")

    normalizer = @normalizers.detect do |normalizer|
      normalizer.column_names.include?(column_name)
    end

    normalizer || @default_normalizer
  end
end