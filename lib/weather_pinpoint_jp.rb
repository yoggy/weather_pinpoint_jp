# -*- coding:utf-8 -*-

#require "weather_pinpoint_jp/version"
require 'net/http'
require 'uri'
require 'open-uri'
require 'json'
require 'rexml/document'
require 'pp'

module WeatherPinpointJp
  # search type
  ADDRESS     = 1
  STATION     = 2
  POSTAL_CODE = 3

  # weather code
  SUNNY      = 100
  CLOUDY     = 200
  RAINY      = 300
  SNOWY      = 400
  HEAT_WAVE  = 550
  HEAVY_RAIN = 850

  # for debug
  @@debug = false

  class << self
    def debug()
      @@debug
    end

    def debug=(flag)
      @@debug = flag
    end

    def get(keyword, type = ADDRESS)
      search_url = "https://weathernews.jp/onebox/api_search.cgi?query=" + URI.encode_www_form_component(keyword)
      json = JSON.parse(URI.open(search_url).read)

      pp json if @@debug

      if json.is_a?(Array) == false || json.size == 0 
        puts "ERROR : cant get url...search_url={search_url}"
        return nil
      end

      html_url = "https://weathernews.jp" + json[0]["url"]

      puts "DEBUG : html_url=#{html_url}" if @@debug

      return load(json[0]["loc"], html_url)
    end

    def load(name, url)
      return Forecast.new(name, url)
    end
  end

  class Forecast
    def initialize(location, url)
      @location = location
      @url = url

      @weather = []

      URI.open(@url) do |f|
        @weather = f.readlines.grep(/\"weather-day__icon\"/).map{|l| l.chomp.gsub(/^.+wxicon\/(\d+)\.png.+\>$/,"\\1")}.map{|s| s.to_i}
        @weather = @weather.map{|n| n == 500 ? 100 : n}
        @weather = @weather.map{|n| n == 650 ? 300 : n}
        @weather = @weather.map{|n| n == 430 ? 400 : n}
      end

        @weather_3h = create_weather_3h(@weather)
    end

    # 天気コードの強さを返す
    def code_rank(a)
      rank = {
          0 => 0,
        100 => 1,
        550 => 2,
        200 => 3,
        300 => 4,
        400 => 5,
        850 => 6,
      }
      return rank[a] if rank.key?(a)
    
      return 10
    end
    
    # どちらの天気コードが影響をおよぼすか？比較
    def compare_code(a, b)
      return code_rank(a) <= code_rank(b)
    end

    # 3時間毎の天気コードに集約
    def create_weather_3h(codes)
      codes_3h = []
      count = 0;
      max_code = 0;
      codes.each {|c|
        if compare_code(max_code ,c)
          max_code = c
        end
        count += 1
        if count == 3
          codes_3h << max_code
          max_code = 0
          count = 0
        end
      }

      codes_3h
    end

    attr_reader :location, :weather, :weather_3h, :url
  end
end

