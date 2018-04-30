#encoding: utf-8

class MobilyApiUnicodeConverter
  def self.convert(str)
    str.chars.map{ |x| '%04x' % x.ord }.join.upcase
  end
end