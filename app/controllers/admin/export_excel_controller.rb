class Admin::ExportExcelController < Admin::ApplicationController

  require 'open-uri'

  def new


  end


  def create

    pattern = params[:pattern]

    url = convert_url(params[:notice_link])

    
    page = Nokogiri::HTML(open(url).read, nil, 'utf-8')

    column_names = []
    comments = []

    pattern.split('/').each do |e|
      column_names.push e.strip
    end

    p column_names.inspect

    page.css('.replylist .obj_rslt').each do |val|
      comment = {}


      val.text.split('/').each_with_index do |e, i|
        comment[column_names[i].to_sym] = e
      end

      comments.push comment
    end

    respond_to do |format|
      format.html
      format.xls { send_data ExcelExporter.export(comments) }
    end
    
  end

  def convert_url(url)
    url
  end
end