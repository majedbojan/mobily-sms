#!/bin/env ruby
# encoding: utf-8
require 'minitest/autorun'
require_relative '../lib/mobily_api_response'


class TestMobilyApiResponseEquality < MiniTest::Unit::TestCase


  def test_equal
    one = MobilyApiResponse.new('1', 'Success')
    two = MobilyApiResponse.new('1', 'Success')
    assert_equal one, two
    assert_equal true, one.eql?(two)
  end

  def test_not_equal
    one = MobilyApiResponse.new('1', 'Success')
    two = MobilyApiResponse.new('2', 'Success')
    assert_equal false, one == two
    assert_equal false, one.eql?(two)
    assert_equal false, 'string'==one
  end

end
