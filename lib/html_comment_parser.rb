class HtmlCommentParser
  def self.import(pattern, url)
    page = Nokogiri::HTML(open(url).read, nil, 'utf-8')

    column_names = []
    comments = []

    pattern.split('/').each do |e|
      column_names.push e.strip
    end

    page.css('.replylist .obj_rslt').each do |val|
      comment = {}

      val.text.split('/').each_with_index do |e, i|
        comment[column_names[i].to_sym] = FormNormalizer.normalize(column_names[i], e)
      end

      comments.push comment
    end
    comments
  end
end