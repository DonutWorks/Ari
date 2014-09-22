require 'open-uri'

class Admin::ExportExcelController < Admin::ApplicationController
  def new
  end

  def create
    pattern = PatternUtil.new(params[:pattern])

    begin
      url = CyworldURL.new(params[:notice_link].strip).to_comment_view_url
    rescue Exception => e
      flash[:error] = e.message
      redirect_to new_admin_export_excel_path
      return
    end

    @comments = HtmlCommentParser.import(pattern, url)

    respond_to do |format|
      #format.html
      #format.csv { send_data ExcelExporter.export(@comments) }
      format.xls
    end
  end
end