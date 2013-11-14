# -*- coding:utf-8 -*-

require "weather_pinpoint_jp/version"
require 'net/http'
require 'uri'
require 'open-uri'
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
  HEAT_WAVE  = 500
  HEAVY_RAIN = 850

  class << self
    def get(keyword, type = ADDRESS)
      search_url = URI.parse("http://weathernews.jp/pinpoint/cgi/search_point.cgi")

      # search location...
      body = ""
      Net::HTTP.start(search_url.host, search_url.port) do |http|
        query = "<search><keyword>#{keyword}</keyword><category>#{type}</category></search>"
        res = http.post(search_url.path, query, {})
        body = res.body
      end

      # get location name & html url
      (name, html_url) = get_name_and_url(body)

      # find the location code...
      location_code = get_code(html_url)

      # return pinpoint forecast instance...
      xml_url = "http://weathernews.jp/pinpoint/xml/#{location_code}.xml"
      return load(name, xml_url)
    end

    def get_name_and_url(xml_str)
      escaped_body = xml_str.gsub(/\&/, "&amp;")

      doc = REXML::Document.new(escaped_body)
      result_num = doc.elements['/pin_result/seac_cnt'].text.to_i
      if result_num == 0
        raise "cannot find the location..."
      end

      html_url = doc.elements['/pin_result/data_ret/ret/url'].text
      name     = doc.elements['/pin_result/data_ret/ret/name'].text

      [name, html_url]
    end

    def get_code(url)
      html = open(url).read
      location_code = html.scan(/obsOrg=(.*?)&xmlFile/)[0][0]
    end

    def load(name, url)
      return Forecast.new(name, url)
    end
  end

  class Forecast
    def initialize(location, url)
      @location = location
      @url = url

      # load xml
      doc = REXML::Document.new(open(url))
      day = doc.elements['//weathernews/data/day']

      # get starttime
      year  = day.attributes['startYear'].to_i
      month = day.attributes['startMonth'].to_i
      date  = day.attributes['startDate'].to_i
      hour  = day.attributes['startHour'].to_i

      @start_time = Time.local(year, month, date, hour, 0, 0)

      # weather
      @weather = []
      day.elements.each('weather/hour') do |e|
        @weather << e.text.to_i
      end

      @weather_3h = create_weather_3h(@weather)

      # temperature
      @temperature = []
      day.elements.each('temperature/hour') do |e|
        @temperature << e.text.to_i
      end

      # precipitation
      @precipitation = []
      day.elements.each('precipitation/hour') do |e|
        @precipitation << e.text.to_i
      end
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

    attr_reader :location, :start_time, :weather, :weather_3h, :temperature, :precipitation
  end
end

