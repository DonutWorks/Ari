require 'open-uri'

class Admin::ExportExcelController < Admin::ApplicationController
  def new
  end

  def create
    @link_url = params[:notice_link]

    pattern = PatternUtil.new(params[:pattern])

    url = CyworldURL.new(@link_url.strip).to_comment_view_url

    comments = HtmlCommentParser.import(pattern, url)

    habitat_format_header = nil
    if params[:export_type] == "habitat"
      habitat_format_header = {"이름" => :username,
                               "주민등록번호" => :identi,
                               "집전화번호" => :home_phone_number,
                               "휴대전화번호" => :phone_number,
                               "응급시 연락처" => :emergency_phone_number,
                               "e-mail" => :email,
                               "지회명" => :local_name,
                               "봉사 시작 일자" => :start_date,
                               "봉사 종료 일자" => :end_date,
                               "단체명" => :organization_name,
                               "단체 아이디" => :habitat_id  }
   end
    send_data ExcelBuilder.build_excel_file(comments, habitat_format_header), :filename => "comments-excel.xls", :type =>  "application/vnd.ms-excel"
  rescue Exception => e
    @error_message = e.message
    render "new"
  end
end