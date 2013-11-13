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

t = forecast.start_time
forecast.weather.each {|w|
  puts "#{t.strftime("%Y/%m/%d %H:%M")} #{w}"
  t += 3600
}
</pre>

<pre>
require 'weather_pinpoint_jp'

forecast = WeatherPinpointJp.get("100000", WeatherPinpointJp::POSTAL_CODE)

puts forecast.location
t = forecast.start_time
forecast.weather.each {|w|
  puts "#{t.strftime("%Y/%m/%d %H:%M")} #{w}"
  t += 3600
}
</pre>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
