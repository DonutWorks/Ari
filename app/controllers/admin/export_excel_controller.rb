require 'open-uri'

class Admin::ExportExcelController < Admin::ApplicationController
  def new

  end

  def create
    url = CyworldURL.new(params[:notice_link]).to_comment_view_url

    comments = HtmlCommentParser.import(params[:pattern], url)

    respond_to do |format|
      format.html
      format.csv { send_data ExcelExporter.export(@comments) }
      format.xls
    end
  end
end