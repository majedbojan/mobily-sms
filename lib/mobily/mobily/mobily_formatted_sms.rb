#encoding: utf-8
require_relative 'mobily_api_json_request_handler'
require_relative 'mobily_api_error'
require_relative 'mobily_api_auth'
require_relative 'mobily_api_unicode_converter'
require_relative 'mobily_sms'

class MobilyFormattedSMS < MobilySMS


  def initialize(auth, numbers=[], sender='', msg='', delete_key=nil, msg_id=nil,
                 domain_name=nil, application_type='70')
    super
    @api_method_name = 'msgSendWK'
    @variable_dict = {}
  end

  def add_variable_for_number(mobile_number, symbol, value)
    return if not @numbers.include?(mobile_number)
    if @variable_dict.has_key?(mobile_number)
      @variable_dict[mobile_number] << [symbol, value]
    else
      @variable_dict.merge!({mobile_number => [[symbol, value]]})
    end
  end

  def generate_msg_key
    if is_valid_key?
      ordered_number_variables = @numbers.map { |num| @variable_dict[num] }
      ordered_number_variables.map { |x| x.map { |y| y.join(',*,') } }.map { |z| z.join(',@,') }.join('***')
    else
      raise 'Cannot generate msgKey, symbol count is inconsistent'
    end
  end

  private

  def prepare_to_send
    super
    @request_handler.add_parameter('msg', MobilyApiUnicodeConverter.convert(@msg))
    @request_handler.add_parameter('msgKey', MobilyApiUnicodeConverter.convert(generate_msg_key))
  end

  def is_valid_key?
    is_value_set_count_consistent? and value_set_count_equals_mobile_number_count?
  end

  def is_value_set_count_consistent?
    1 == @variable_dict.values.map { |x| x.size }.uniq.size
  end

  def value_set_count_equals_mobile_number_count?
    @variable_dict.size == @numbers.size
  end

end