class HtmlCommentParser
  def self.import(pattern, url)
    page = Nokogiri::HTML(open(url).read, nil, 'utf-8')
    normalizer = FormNormalizer.new

    column_names = pattern.column_names
    comments = []

    reply_count = page.at_css('input#reply_cnt').attr('value').to_i
    page_count = reply_count / 50 + 1
    (1..page_count).each do |i|
      page_url = url + "&replpag=#{i}"
      page = Nokogiri::HTML(open(page_url).read, nil, 'utf-8')

      page.css('.replylist .obj_rslt').each do |val|
        comment = {}
        if pattern.compare(val.text)
          comment[:invalid] = false
          val.text.split('/').each_with_index do |e, i|
            comment[column_names[i].to_sym] = normalizer.normalize(column_names[i], e)
          end
        else
          comment[:invalid] = true
          comment[column_names[0].to_sym] = val.text
        end
        comments.push comment
      end
    end

    comments
  end
end