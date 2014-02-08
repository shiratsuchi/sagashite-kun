require 'bundler/setup'
require 'capybara-webkit'
require 'nokogiri'
require 'open-uri'
require 'kconv'

title = ARGV[0].to_s

def hulu(title)
  url = "http://www.hulu.jp/search?q=" + title

  driver = Capybara::Webkit::Driver.new 'app'
  driver.visit url
  node = driver.find_css('.promo-title-link')[0]

  if node
    p node.text + "は Hulu にあるよ。"
  else
    p title + "は Hulu にはないみたいだよ。"
  end
end

def tsutaya(title)
  url = "http://www.discas.net/netdvd/vod/searchVod.do?i=2&df=&k=" + URI.encode(title.tosjis)

  doc = Nokogiri::HTML.parse(open(url).read.toutf8, nil, 'UTF-8')

  node = doc.css('.tblColType01 tbody tr th a')

  if node.empty?
    p title + "は TSUTAYA TV にはないみたいだよ。"
  else
    p title + "は TSUTAYA TV にあるよ。"
  end
end

def sky(title)
  url = "http://vod.skyperfectv.co.jp/program_search.php?GENRE=&CHANNEL=&SUBMIT=%E6%A4%9C%E7%B4%A2&KEYWORD=" + URI.encode(title)
  
  doc = Nokogiri::HTML(open(url))
  
  node = doc.css('.number')
  
  if node.empty?
    p title + "は スカパー にはないみたいだよ。"
  else
    p title + "は スカパー にあるよ。"
  end
end

hulu(title)
tsutaya(title)
sky(title)