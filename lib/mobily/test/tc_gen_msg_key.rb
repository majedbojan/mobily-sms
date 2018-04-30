#!/bin/env ruby
# encoding: utf-8
require 'minitest/autorun'
require_relative '../lib/mobily_formatted_sms'

class TestGenerateMsgKey < MiniTest::Unit::TestCase


  def test_that_valid_msg_key_is_generated_when_vars_added_in_same_order
    msg = 'Hi (1), your subscription will end on (2).'
    numbers = %w(966505555555 966504444444)
    sms = MobilyFormattedSMS.new(nil, numbers, 'NEW SMS', msg)
    sms.add_variable_for_number('966505555555', '(1)', 'Ahmad')
    sms.add_variable_for_number('966505555555', '(2)', '31/12/2013')
    sms.add_variable_for_number('966504444444', '(1)', 'Mohamed')
    sms.add_variable_for_number('966504444444', '(2)', '01/11/2013')
    exp_msg_key = '(1),*,Ahmad,@,(2),*,31/12/2013***(1),*,Mohamed,@,(2),*,01/11/2013'
    assert_equal exp_msg_key, sms.generate_msg_key
  end

  def test_that_valid_msg_key_is_generated_when_vars_added_in_diff_order
    msg = 'Hi (1), your subscription will end on (2).'
    numbers = %w(966505555555 966504444444)
    sms = MobilyFormattedSMS.new(nil, numbers, 'NEW SMS', msg)
    sms.add_variable_for_number('966504444444', '(1)', 'Mohamed')
    sms.add_variable_for_number('966505555555', '(1)', 'Ahmad')
    sms.add_variable_for_number('966505555555', '(2)', '31/12/2013')
    sms.add_variable_for_number('966504444444', '(2)', '01/11/2013')
    exp_msg_key = '(1),*,Ahmad,@,(2),*,31/12/2013***(1),*,Mohamed,@,(2),*,01/11/2013'
    assert_equal exp_msg_key, sms.generate_msg_key
  end

  def test_cannot_insert_var_for_mobile_not_added
    msg = 'Hi (1), your subscription will end on (2).'
    numbers = %w(966505555555 966504444444)
    sms = MobilyFormattedSMS.new(nil, numbers, 'NEW SMS', msg)
    assert_nil sms.add_variable_for_number('1', '(1)', 'Mohamed')
  end

  def test_throws_when_not_enough_value_sets
    msg = 'Hi (1), your subscription will end on (2).'
    numbers = %w(966505555555 966504444444)
    sms = MobilyFormattedSMS.new(nil, numbers, 'NEW SMS', msg)
    sms.add_variable_for_number('966505555555', '(1)', 'Ahmad')
    sms.add_variable_for_number('966505555555', '(2)', '31/12/2013')
    assert_raises RuntimeError do
      sms.generate_msg_key
    end
  end

  def test_throws_when_value_sets_are_unbalanced
    msg = 'Hi (1), your subscription will end on (2).'
    numbers = %w(966505555555 966504444444)
    sms = MobilyFormattedSMS.new(nil, numbers, 'NEW SMS', msg)
    sms.add_variable_for_number('966505555555', '(1)', 'Ahmad')
    sms.add_variable_for_number('966505555555', '(2)', '31/12/2013')
    sms.add_variable_for_number('966504444444', '(1)', 'Mohamed')
    assert_raises RuntimeError do
      sms.generate_msg_key
    end
  end
end
