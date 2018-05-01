module Mobily
  class Configuration
    attr_accessor :username, :password, :smshost

    def initialize
      @username = nil
      @password = nil
      @smshost  = nil
    end
  end
end
