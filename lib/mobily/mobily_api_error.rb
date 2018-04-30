class MobilyApiError < StandardError
  attr_accessor :code, :msg_english, :msg_arabic

  def initialize(code, msg_arabic, msg_english)
    super(msg_english)
    @code = code
    @msg_arabic = msg_arabic
    @msg_english = msg_english
  end
end
