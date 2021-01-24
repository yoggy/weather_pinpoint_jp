# -*- coding:utf-8 -*-
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)

require 'weather_pinpoint_jp'

forecast = WeatherPinpointJp.get("東京都千代田区")

puts forecast.location
t = forecast.start_time
forecast.weather.each {|w|
  puts "#{w}"
}
