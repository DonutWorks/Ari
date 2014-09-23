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

    comments = HtmlCommentParser.import(pattern, url)
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet
    invalid_format = Spreadsheet::Format.new :color => :red,
                                 :weight => :bold

    comments.first.keys.each_with_index do |key, index|
      sheet1.row(0).push(key.to_s) if index > 0
    end

    comments.each_with_index do |comment, index_out|
      invalid = false
      comment.values.each_with_index do |value, index_in|
        if index_in == 0
          invalid = value
        else
          sheet1.row(index_out+1).default_format = invalid_format if invalid
          sheet1.row(index_out+1).push(value)
        end
      end
    end

    bookstring = StringIO.new
    book.write bookstring

    send_data bookstring.string, :filename => "comments-excel.xls", :type =>  "application/vnd.ms-excel"
    #redirect_to admin_root_path
  end
end