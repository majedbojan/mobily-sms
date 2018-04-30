require_relative 'mobily_api_json_request_handler'
require_relative 'mobily_api_error'
require_relative 'mobily_api_auth'

class MobilyAccount
  def initialize(auth)
    @auth = auth
  end

  def change_password(new_password)
    # changePassword api method wrapper
    request_handler = MobilyApiJsonRequestHandler.new(@auth)
    request_handler.set_api_method('changePassword')
    request_handler.add_parameter('newPassword', new_password)
    request_handler.handle
  end

  def forgot_password(send_to_email=true)
    # forgotPassword api method wrapper
    request_handler = MobilyApiJsonRequestHandler.new(@auth)
    request_type = send_to_email ? 2 : 1
    request_handler.set_api_method('forgetPassword')
    request_handler.add_parameter('type', request_type)
    request_handler.handle
  end

  def check_balance
    # balance api method wrapper
    request_handler = MobilyApiJsonRequestHandler.new(@auth)
    request_handler.set_api_method('balance')
    request_handler.handle.get('balance')
  end

end