class Admin::GatesController < Admin::ApplicationController
  def new
    @gate = Gate.new    
  end

  def create
    @gate = Gate.new(gate_params)

    if @gate.save
      redirect_to result_admin_gate_path(@gate)
    end
  end

  def result
    @gate = Gate.find(params[:id])
    @shortenURL = shortenURL(gate_url(@gate))
  end

private
  def gate_params
    params.require(:gate).permit(:title, :link, :content, :duedate)
  end

  def shortenURL(longurl)
    require "uri"
    require "net/http"

    uri = URI.parse("https://www.googleapis.com/urlshortener/v1/url?key=AIzaSyCPjcArjKfGKsxMfa9DPXME7peALnwpLY0")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
    request = Net::HTTP::Post.new(uri.path,{'Content-Type' =>'application/json'})
    request.body = '{"longUrl" : "'+longurl+'"}'
    response = http.request(request)
    hash = JSON.parse( response.body.to_s )
    return hash["id"]
  end
end
