require 'net/http'
require 'json'
require 'uri'

class MobilyApiRequest
  attr_accessor :api_host, :api_end_point

  def initialize(api_host='mobily.ws', api_end_point='/api/json/')
    @api_host = api_host
    @api_end_point = api_end_point
  end

  def send(request_data, content_type)
    content_type = 'application/'.concat(content_type).concat('; charset=utf-8')
    req = Net::HTTP::Post.new(@api_end_point, initheader={'Content-Type' => content_type})
    req.body = request_data
    res = Net::HTTP.start(@api_host, 80) do |http|
      http.request(req)
    end
    res.body
  end
end