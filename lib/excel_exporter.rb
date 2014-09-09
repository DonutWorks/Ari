require 'csv'

class ExcelExporter
  def self.export(comments)
    CSV.generate({col_sep: "\t"}) do |csv|
      csv << comments.first.keys
      comments.each do |comment|
        csv << comment.values
      end
    end
  end
end