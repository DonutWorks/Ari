require 'open-uri'

class Admin::ExportExcelController < Admin::ApplicationController
  def new
  end

  def create
    pattern = PatternUtil.new(params[:pattern])

    begin
      url = CyworldURL.new(params[:notice_link].strip).to_comment_view_url
    rescue Exception => e
      flash[:error] = "주소가 유효하지 않습니다. 다시 한번 확인해주세요."
      redirect_to new_admin_export_excel_path
      return
    end

    @comments = HtmlCommentParser.import(pattern, url)

    respond_to do |format|
      format.html
      format.csv { send_data ExcelExporter.export(@comments) }
      format.xls
    end
  end
end