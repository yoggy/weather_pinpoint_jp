# -*- coding:utf-8 -*-
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)

require 'weather_pinpoint_jp'

forecast = WeatherPinpointJp.get("100000", WeatherPinpointJp::POSTAL_CODE)

puts forecast.location
t = forecast.start_time
forecast.weather.each {|w|
  puts "#{t.strftime("%Y/%m/%d %H:%M")} #{w}"
  t += 3600
}
