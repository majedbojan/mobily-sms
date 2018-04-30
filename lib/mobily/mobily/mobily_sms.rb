require_relative 'mobily_api_json_request_handler'
require_relative 'mobily_api_error'
require_relative 'mobily_api_auth'
require_relative 'mobily_api_unicode_converter'

class MobilySMS
  attr_reader :date_send, :time_send
  attr_accessor :auth, :sender, :msg, :delete_key, :msg_id, :domain_name, :request_handler


  def initialize(auth, numbers=[], sender='', msg='', delete_key=nil, msg_id=nil,
                 domain_name=nil, application_type='70')
    @auth = auth
    @numbers = numbers
    @sender = sender
    @msg = msg
    @date_send = 0
    @time_send = 0
    @delete_key = delete_key
    @msg_id = msg_id
    @domain_name = domain_name
    @application_type = application_type
    @api_method_name = 'msgSend'
    @request_handler = MobilyApiJsonRequestHandler.new(@auth)
  end

  def add_number(number)
    @numbers << number
  end

  def get_numbers_as_csv
    @numbers.join(',')
  end

  def self.can_send?

    # send status api method wrapper, doesn't need authentication
    request_handler = MobilyApiJsonRequestHandler.new
    request_handler.set_api_method('sendStatus')
    begin
      response = request_handler.handle
    rescue MobilyApiError
      false
    else
      response.get('result') == '1'
    end
  end

  def send
    # send sms api method wrapper
    prepare_to_send
    @request_handler.handle
  end

  def delete
    # send sms api method wrapper
    return if @delete_key.nil?
    request_handler = MobilyApiJsonRequestHandler.new(@auth)
    request_handler.set_api_method('deleteMsg')
    request_handler.add_parameter('deleteKey', @delete_key)
    request_handler.handle
  end

  def schedule_to_send_on(day, month, year, hour=0, min=0, sec=0)
    @time_send = '%02d:%02d:%02d' % [hour, min, sec]
    @date_send = '%02d/%02d/%04d' % [month, day, year]
  end

  private

  def prepare_to_send
    @request_handler.set_api_method(@api_method_name)
    @request_handler.add_parameter('sender', @sender)
    @request_handler.add_parameter('msg', @msg)
    @request_handler.add_parameter('numbers', get_numbers_as_csv)
    @request_handler.add_parameter('dateSend', @date_send)
    @request_handler.add_parameter('timeSend', @time_send)
    @request_handler.add_parameter('deleteKey', @delete_key)
    @request_handler.add_parameter('msgId', @msg_id)
    @request_handler.add_parameter('lang', '3')
    @request_handler.add_parameter('applicationType', @application_type)
    @request_handler.add_parameter('domainName', @domain_name)
  end
end
