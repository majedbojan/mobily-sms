#!/bin/env ruby
# encoding: utf-8
require 'minitest/autorun'
require_relative '../lib/mobily_api_json_request_handler'
require_relative '../lib/mobily_api_response'
require_relative '../lib/mobily_api_response'


class TestMobilyApiJsonRequestHandler < MiniTest::Unit::TestCase


  def test_json_building
    expected_json = '{"Data":{"Method":"balance","Auth":{"mobile":"test","password":"test"}}}'
    handler = MobilyApiJsonRequestHandler.new
    handler.auth = MobilyApiAuth.new('test', 'test')
    handler.set_api_method('balance')
    assert_equal expected_json, handler.get_request_data
  end

  def test_response_parsing_success
    fake_response = '' '{
        "status":1,
        "ResponseStatus":"success",
        "Data":{
        "result":"1",
        "MessageAr":"يمكنك الإرسال الآن",
        "MessageEn":"You can send SMS now"
        },
        "Error":null
        }
        ' ''
    expected_response = MobilyApiResponse.new(1, 'success')
    expected_response.add_data('result', '1')
    expected_response.add_data('MessageAr', 'يمكنك الإرسال الآن')
    expected_response.add_data('MessageEn', 'You can send SMS now')
    handler = MobilyApiJsonRequestHandler.new
    handler.request = MobilyApiRequestStub.new(fake_response)
    assert_equal expected_response, handler.handle
  end

  def test_response_parsing_throws
    fake_response = '' '{
        "status":1,
        "ResponseStatus":"fail",
        "Data":null,
        "Error":{
        "ErrorCode":0,
        "MessageAr":"بوابة غير معرفة لدينا",
        "MessageEn":"API not exist"
        }
        }' ''
    err = assert_raises MobilyApiError do
      handler = MobilyApiJsonRequestHandler.new
      handler.request = MobilyApiRequestStub.new(fake_response)
      handler.handle
    end
    assert_equal 'بوابة غير معرفة لدينا', err.msg_arabic
    assert_equal 'API not exist', err.msg_english
    assert_equal 0, err.code

  end
end


class MobilyApiRequestStub
  def initialize(fake_response)
    @fake_response = fake_response
  end

  def send(request_data, content_type)
    @fake_response
  end
end