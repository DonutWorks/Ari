require 'open-uri'

class Admin::ExportExcelController < Admin::ApplicationController
  def new

  end

  def create
    pattern = PatternUtil.new(params[:pattern])
    url = CyworldURL.new(params[:notice_link]).to_comment_view_url

    page = Nokogiri::HTML(open(url).read, nil, 'utf-8')

    column_names = pattern.column_names
    comments = []

    page.css('.replylist .obj_rslt').each do |val|

      if pattern.compare(val.text)
        comment = {}

        val.text.split('/').each_with_index do |e, i|
          comment[column_names[i].to_sym] = FormNormalizer.normalize(column_names[i], e)
        end
        
      else
        comment[:unvalid] = true
      end

      comments.push comment
    end

    respond_to do |format|
      format.html
      format.xls { send_data ExcelExporter.export(comments) }
    end
  end

end