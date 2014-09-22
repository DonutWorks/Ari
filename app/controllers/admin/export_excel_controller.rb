require 'open-uri'

class Admin::ExportExcelController < Admin::ApplicationController
  def new
  end

  def create
    pattern = PatternUtil.new(params[:pattern])

    begin
      url = CyworldURL.new(params[:notice_link]).to_comment_view_url
    rescue Exception => e
      flash[:error] = e.message
      redirect_to new_admin_export_excel_path
      return
    end

    comments = HtmlCommentParser.import(pattern, url)

    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet

    comments.first.keys.each do |key|
      sheet1.row(0).push(key.to_s)
    end

    comments.each_with_index do |comment, index|
      comment.values.each do |value|
        sheet1.row(index+1).push(value)
      end
    end

    bookstring = StringIO.new 
    book.write bookstring
    
    send_data bookstring.string, :filename => "comments-excel.xls", :type =>  "application/vnd.ms-excel" 
    #redirect_to admin_root_path
  end
end