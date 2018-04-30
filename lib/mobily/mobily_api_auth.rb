class MobilyApiAuth
  attr_accessor :mobile_number, :password

  def initialize(mobile_number, password)
    @mobile_number = mobile_number
    @password = password
  end
end
