require 'open-uri'

class Admin::ExportExcelController < Admin::ApplicationController
  def new

  end

  def create
    pattern = params[:pattern]
    url = convert_url(params[:notice_link])

    page = Nokogiri::HTML(open(url).read, nil, 'utf-8')

    column_names = []
    @comments = []

    pattern.split('/').each do |e|
      column_names.push e.strip
    end

    page.css('.replylist .obj_rslt').each do |val|
      comment = {}

      val.text.split('/').each_with_index do |e, i|
        comment[column_names[i].to_sym] = FormNormalizer.normalize(column_names[i], e)
      end

      @comments.push comment
    end

    respond_to do |format|
      format.html
      format.csv { send_data ExcelExporter.export(@comments) }
      format.xls
    end
  end

private
  def convert_url(url)
    shorten_url_template = URITemplate.new("http://{host}{/segments*}")
    params = shorten_url_template.extract(url)["segments"]
    query_params = {
      club_id: params[0][0..7],
      board_type: params[0][8],
      board_no: params[0][9..-1],
      item_seq: params[1]
    }
    comment_list_url = "http://club.cyworld.com/club/board/common/CommentList.asp"
    comment_list_url_template = URITemplate.new("#{comment_list_url}{?#{query_params.keys.join(',')}}")
    return comment_list_url_template.expand(query_params)
  end
end