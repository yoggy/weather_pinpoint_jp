# -*- coding:utf-8 -*-
require 'rubygems'
require 'bundler/setup'
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'minitest/autorun'

require 'weather_pinpoint_jp'

class TestLoad < Minitest::Test
  def setup
  end

  def test_load_failed
    f = nil
    begin
      f = WeatherPinpointJp.load("test_data", File.dirname(__FILE__) + "/aaa.xml")
    rescue Exception => e
    end
    assert_equal f.nil?, true
  end

  def test_get_name_and_url
    result_xml = open(File.dirname(__FILE__) + "/test_data_result.xml").read
    (name, url) = WeatherPinpointJp.get_name_and_url(result_xml)
    assert_equal name, "地名1"
    assert_equal url, "http://example.com/result_url_1?text=1&test2=2&test3=3"
  end

  def test_get_code
    url = File.dirname(__FILE__) + "/test_data.html"
    code = WeatherPinpointJp.get_code(url)
    assert_equal code, "12345"
  end

  def test_load
    f = WeatherPinpointJp.load("test_data", File.dirname(__FILE__) + "/test_data.xml")
    assert_equal f.nil?, false, "load() failed..."

    # start time
    assert_equal  f.start_time, Time.new(2013, 11, 12, 13, 0, 0) 

    # weather
    assert_equal f.weather.size, 36
    f.weather.each_with_index {|w, i|
      w = ((i % 4) + 1) * 100
    }

    # temperature
    assert_equal f.temperature.size, 36
    f.temperature.each_with_index {|t, i|
      assert_equal t, i + 1
    }

    # precipitation
    assert_equal f.precipitation.size, 36
    f.precipitation.each_with_index {|p, i|
      assert_equal p, i + 1 + 10
    }
  end
end

