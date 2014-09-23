class ExcelImporter
  def self.import(filename)
    file = Tempfile.new(['data','.xlsx'])
    file.binmode
    file.write(filename.read)

    data = Roo::Excelx.new(file.path)
  end

end