require 'open-uri'

class Admin::ExportExcelController < Admin::ApplicationController
  def new

  end

  def create
    pattern = params[:pattern]
    url = CyworldURL.new(params[:notice_link]).to_comment_view_url

    page = Nokogiri::HTML(open(url).read, nil, 'utf-8')

    column_names = []
    @comments = []

    pattern.split('/').each do |e|
      column_names.push e.strip
    end

    page.css('.replylist .obj_rslt').each do |val|
      comment = {}

      val.text.split('/').each_with_index do |e, i|
        comment[column_names[i].to_sym] = FormNormalizer.normalize(column_names[i], e)
      end

      @comments.push comment
    end

    respond_to do |format|
      format.html
      format.csv { send_data ExcelExporter.export(@comments) }
      format.xls
    end
  end
end