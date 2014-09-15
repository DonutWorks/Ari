class HtmlCommentParser
  def self.import(pattern, url)
    page = Nokogiri::HTML(open(url).read, nil, 'utf-8')
    normalizer = FormNormalizer.new

    column_names = pattern.column_names
    comments = []

    page.css('.replylist .obj_rslt').each do |val|
      if pattern.compare(val.text)
        comment = {}
        val.text.split('/').each_with_index do |e, i|
          comment[column_names[i].to_sym] = normalizer.normalize(column_names[i], e)
        end
      else
        comment[:unvalid] = true
      end
      comments.push comment
    end
    comments
  end
end