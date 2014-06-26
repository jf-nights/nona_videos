# coding: utf-8
require 'cinch'
require 'open-uri'
require 'nokogiri'
require 'date'


Encoding.default_internal = "UTF-8"

    def get_img(date)
      uri = date.strftime("http://www.xnxx.com/cartoon_of_the_day/cartoons/%Y/%Y-%m-%d-cartoon.htm")
      charset = nil
      html = open(uri) do |f|
        charset = f.charset
        f.read
      end
      doc = Nokogiri::HTML.parse(html, nil, charset)

      arr = []
      arr << uri
      arr << doc.xpath('//img').attribute('src').value
      arr << doc.xpath('//img').attribute('alt').value
      return arr
    end

    def send(arr, m)
      arr.each do |str|
        m.channel.send(str)
      end
    end


bot = Cinch::Bot.new do
  configure do |c|
    c.server = 'localhost'
    c.nick = 'xvideos'
    c.user = 'xvideos'
    c.encoding = 'UTF-8'
    c.channels = ['#kmc-xvideos']
    c.port = 36660
  end

  on :message do |m|
    input = m.message
    if input =~ /^#today$/
      arr = get_img(Date.today)
      send(arr, m)

    elsif input =~ /^#random$/
      d1 = Date.new(2009, 11, 4)
      date = d1 + rand(Date.today - d1)
      arr = get_img(date)
      send(arr, m)

    end
  end



end
bot.start
