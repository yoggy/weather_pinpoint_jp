# WeatherPinpointJp

weather information library for ruby

## Installation

Add this line to your application's Gemfile:

    gem 'weather_pinpoint_jp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install weather_pinpoint_jp

## Usage

<pre>
require 'weather_pinpoint_jp'

forecast = WeatherPinpointJp.get("東京都千代田区")

puts forecast.location
forecast.weather.each {|w|
  puts "#{w}"
}
</pre>

<pre>
require 'weather_pinpoint_jp'

forecast = WeatherPinpointJp.get("100000")

puts forecast.location
forecast.weather.each {|w|
  puts "#{w}"
}
</pre>

