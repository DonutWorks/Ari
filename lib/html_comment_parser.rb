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

        comment[:invalid] = !pattern.compare(val.text)

        val.text.split('/').each_with_index do |e, i|
          if column_names[i].blank?
            comment[("invalid_data" + i.to_s).to_sym] = e
          else
            comment[column_names[i].to_sym] = normalizer.normalize(column_names[i], e)
          end
        end

        comments.push comment
      end
    end

    comments
  end
end