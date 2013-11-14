# -*- coding:utf-8 -*-
require 'rubygems'
require 'bundler/setup'
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'minitest/autorun'

require 'weather_pinpoint_jp'

class Test3h < Minitest::Test
  def setup
  end

  def test_load
    f = WeatherPinpointJp.load("test_data", File.dirname(__FILE__) + "/test_data2.xml")
    assert_equal f.nil?, false, "load() failed..."

    assert_equal f.weather_3h.size, 10 # 32/3 = 10.66... => 10

    assert_equal f.weather_3h[0], 100
    assert_equal f.weather_3h[1], 200
    assert_equal f.weather_3h[2], 300
    assert_equal f.weather_3h[3], 400
    assert_equal f.weather_3h[4], 500
    assert_equal f.weather_3h[5], 850
    assert_equal f.weather_3h[6], 200
    assert_equal f.weather_3h[7], 300
    assert_equal f.weather_3h[8], 400
    assert_equal f.weather_3h[9], 850
  end
end

