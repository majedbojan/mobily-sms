class MobilyApiResponse
  attr_accessor :status, :response_status, :data

  def initialize(status, response_status)
    @status = status
    @response_status = response_status.downcase
    @data = {}
  end

  def add_data(key, value)
    @data.merge!({key => value})
  end

  def get(key)
    @data.has_key?(key) ? @data[key] : nil
  end

  def == other
    eql?(other)
  end

  def eql? other
    [@status, @response_status, @data].eql?([other.status, other.response_status, other.data])
  end
end