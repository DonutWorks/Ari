class ExcelImporter
  def self.import(filename)
    if filename.original_filename.include? "xlsx"
      file = Tempfile.new(['data','.xlsx'])
      file.binmode
      file.write(filename.read)

      data = Roo::Excelx.new(file.path)
    
    elsif filename.original_filename.include? "xls"
      file = Tempfile.new(['data','.xls'])
      file.binmode
      file.write(filename.read)

      data = Roo::Excel.new(file.path)
    end
  end

end