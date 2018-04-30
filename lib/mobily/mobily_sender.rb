require_relative 'mobily_api_json_request_handler'
require_relative 'mobily_api_error'
require_relative 'mobily_api_auth'

class MobilySender
  def initialize(auth)
    @auth = auth
  end

  def request_mobile_number_license(mobile_number)
    request_handler = MobilyApiJsonRequestHandler.new(@auth)
    request_handler.set_api_method('addSender')
    request_handler.add_parameter('sender', mobile_number)
    response = request_handler.handle
    response.get('senderId')
  end

  def activate_mobile_number_license(sender_id, activation_code)
    request_handler = MobilyApiJsonRequestHandler.new(@auth)
    request_handler.set_api_method('activeSender')
    request_handler.add_parameter('senderId', sender_id.tr('#', ''))
    request_handler.add_parameter('activeKey', activation_code)
    request_handler.handle
  end

  def is_mobile_number_license_active?(sender_id)
    request_handler = MobilyApiJsonRequestHandler.new(@auth)
    request_handler.set_api_method('checkSender')
    request_handler.add_parameter('senderId', sender_id.tr('#', ''))
    begin
      response = request_handler.handle
    rescue MobilyApiError
      false
    else
      response.get('result') == '1'
    end
  end

  def request_alphabetical_license(sender)
    request_handler = MobilyApiJsonRequestHandler.new(@auth)
    request_handler.set_api_method('addAlphaSender')
    request_handler.add_parameter('sender', sender)
    request_handler.handle
  end

  def get_activation_status_for_all_senders
    request_handler = MobilyApiJsonRequestHandler.new(@auth)
    request_handler.set_api_method('checkAlphasSender')
    request_handler.handle.data
  end
end