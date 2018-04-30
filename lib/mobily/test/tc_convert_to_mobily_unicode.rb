#!/bin/env ruby
# encoding: utf-8
require 'minitest/autorun'
require_relative '../lib/mobily_api_unicode_converter'

class TestMobilyUnicodeConverter < MiniTest::Unit::TestCase


  def test_arabic_string_from_api_docs
    exp = '06270647064406270020064806330647064406270020062806430020064506390020006D006F00620069006C0079002E00770073'
    assert_equal exp, MobilyApiUnicodeConverter.convert('اهلا وسهلا بك مع mobily.ws')
  end

  def test_single_byte_characters
    assert_equal '000D', MobilyApiUnicodeConverter.convert("\r")
    assert_equal '004D', MobilyApiUnicodeConverter.convert('M')
  end

  def test_multi_byte_characters
    assert_equal '2022', MobilyApiUnicodeConverter.convert('•')
    assert_equal '03C0', MobilyApiUnicodeConverter.convert('π')
  end

end