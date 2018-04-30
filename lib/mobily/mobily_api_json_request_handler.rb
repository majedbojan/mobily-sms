require 'json'
require_relative 'mobily_api_request'
require_relative 'mobily_api_auth'
require_relative 'mobily_api_error'
require_relative 'mobily_api_response'

class MobilyApiJsonRequestHandler
  attr_accessor :auth, :request

  def initialize(auth=nil, request=MobilyApiRequest.new)
    @request = request
    @params = {}
    @content_type = 'json'
    @json_dict = {'Data' => {}}
    @auth = auth
  end

  def add_auth(auth)
    if auth.is_a? MobilyApiAuth
      @json_dict['Data'].merge!({'Auth' => {'mobile' => auth.mobile_number, 'password' => auth.password}})
    end
  end

  def set_api_method(method_name)
    @json_dict['Data'].merge!({'Method' => method_name})
  end

  def add_parameter(key, value)
    if !value.nil?
      @params.merge!({key => value})
    end
  end

  def get_request_data
    if @params.size > 0
      @json_dict['Data'].update({'Params' => @params})
    end
    add_auth(@auth)
    JSON.generate(@json_dict)
  end

  def handle
    parse_response(request.send(get_request_data, @content_type))
  end

  private

  def parse_response(data)
    json_dict = JSON.parse(data)
    if not json_dict['Error'].nil?
      error = json_dict['Error']
      raise MobilyApiError.new(error['ErrorCode'], error['MessageAr'], error['MessageEn'])
    end
    response = MobilyApiResponse.new(json_dict['status'], json_dict['ResponseStatus'])
    json_dict['Data'].each { |k, v| response.add_data(k, v) }
    response
  end
end
