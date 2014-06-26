# coding: utf-8
require 'cinch'
require 'open-uri'
require 'nokogiri'


Encoding.default_internal = "UTF-8"


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
      uri = (Time.now.utc).strftime("http://www.xnxx.com/cartoon_of_the_day/cartoons/%Y/%Y-%m-%d-cartoon.htm")

      charset = nil
      html = open(uri) do |f|
        charset = f.charset
        f.read
      end
      doc = Nokogiri::HTML.parse(html, nil, charset)

      imgURI = doc.xpath('//img').attribute('src').value
      imgAlt = doc.xpath('//img').attribute('alt').value
      m.channel.send(imgURI)
      m.channel.send(imgAlt)
    end
  end

end
bot.start
