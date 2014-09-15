class PatternUtil
  def initialize(pattern)
    @pattern = pattern
  end

  def count_column(val = @pattern)
    val.count("/") + 1
  end

  def compare(comment)
    if count_column == count_column(comment)
      true
    else
      false
    end
  end

  def column_names
    column_names = []

    @pattern.split('/').each do |e|
      column_names.push e
    end

    return column_names
  end
end