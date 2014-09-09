class Admin::ExportExcelController < Admin::ApplicationController


  def export


  end


  def export_excel

    pattern = params[:format]

    url = convert_url(params[:notice_link])
    page = Nokogiri::HTML(open(url), nil, 'utf-8')

    column_names = []
    comments = []

    pattern.split('/').each do |e|
      column_names.push e.strip
    end

    page.css('.replylist .obj_rslt').each do |val|
      comment = {}


      val.text.split('/').each_with_index do |e, i|
        comment[column_name[i].to_sym] = e
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