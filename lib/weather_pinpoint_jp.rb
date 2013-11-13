# -*- coding:utf-8 -*-

require "weather_pinpoint_jp/version"
require 'net/http'
require 'uri'
require 'nokogiri'
require 'open-uri'
require 'pp'

module WeatherPinpointJp
  # search type
  ADDRESS     = 1
  STATION     = 2
  POSTAL_CODE = 3

  class << self
    def get(keyword, type = ADDRESS)
      search_url = URI.parse("http://weathernews.jp/pinpoint/cgi/search_point.cgi")
      html_url   = nil
      xml_url    = nil
      name       = nil

      # search location...
      Net::HTTP.start(search_url.host, search_url.port) do |http|
        query = "<search><keyword>#{keyword}</keyword><category>#{type}</category></search>"

        res = http.post(search_url.path, query, {})
        escaped_body = res.body.gsub(/\&/, "&amp;")
        doc = Nokogiri::XML(escaped_body)

        result_num = doc.search('seac_cnt').children[0].content.to_i
        if result_num == 0
          raise "cannot find the location..."
        end

        html_url = doc.search('url').children[0].content
        name     = doc.search('name').children[0].content
      end

      # get html...
      doc = Nokogiri::HTML(open(html_url))

      # find the location code...
      onload_str = doc.search('body').first.attribute('onload').value
      location_code = onload_str.scan(/obsOrg=(.*?)&xmlFile/)[0][0]

      # return pinpoint forecast instance...
      xml_url = "http://weathernews.jp/pinpoint/xml/#{location_code}.xml"
      return load(name, xml_url)
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
      doc = Nokogiri::XML(open(url))
      day = doc.xpath('//weathernews/data/day')[0]

      # get starttime
      year  = day.attribute('startYear').content.to_i
      month = day.attribute('startMonth').content.to_i
      date  = day.attribute('startDate').content.to_i
      hour  = day.attribute('startHour').content.to_i

      @start_time = Time.local(year, month, date, hour, 0, 0)

      # weather
      @weather = []
      day.xpath('weather/hour').children.each do |e|
        @weather << e.content.to_i
      end

      # temperature
      @temperature = []
      day.xpath('temperature/hour').children.each do |e|
        @temperature << e.content.to_i
      end

      # precipitation
      @precipitation = []
      day.xpath('precipitation/hour').children.each do |e|
        @precipitation << e.content.to_i
      end
    end

    attr_reader :location, :start_time, :weather, :temperature, :precipitation
  end
end

