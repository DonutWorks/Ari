class Admin::ExportExcelController < Admin::ApplicationController


  def export
    pattern = "이름/기수/전화번호"

    url = 'http://club.cyworld.com/club/board/common/CommentList.asp?club_id=52252462&board_type=1&board_no=36&item_seq=157146265'
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


  def export_excel
    format = params[:format]
    notice_link = params[:notice_link]
    
  end
end