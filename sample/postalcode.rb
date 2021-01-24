# -*- coding:utf-8 -*-
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)

require 'weather_pinpoint_jp'

WeatherPinpointJp.debug = true

forecast = WeatherPinpointJp.get("2300046")

puts forecast.location
t = forecast.start_time
forecast.weather.each {|w|
  puts "#{w}"
}
