require 'open-uri'

class Admin::ExportExcelController < Admin::ApplicationController
  def new
    @is_test = params[:is_test] 
  end

  def create
    @link_url = params[:notice_link]

    pattern = PatternUtil.new(params[:pattern])

    begin
      url = CyworldURL.new(@link_url.strip).to_comment_view_url
    rescue Exception => e
      @error_message = e.message
      render "new"
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

    if params[:is_test] == "true"
      book.write "public/test/comments-excel.xls"
      render "new"
    else
      bookstring = StringIO.new
      book.write bookstring

      send_data bookstring.string, :filename => "comments-excel.xls", :type =>  "application/vnd.ms-excel"
      #redirect_to admin_root_path
    end
  end
end