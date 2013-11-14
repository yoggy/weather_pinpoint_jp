# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'weather_pinpoint_jp/version'

Gem::Specification.new do |spec|
  spec.name          = "weather_pinpoint_jp"
  spec.version       = WeatherPinpointJp::VERSION
  spec.authors       = ["yoggy"]
  spec.email         = ["yoggy0@gmail.com"]
  spec.description   = %q{weather information library for ruby}
  spec.summary       = %q{weather information library for ruby}
  spec.homepage      = "https://github.com/yoggy/weather_pinpoint_jp"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
