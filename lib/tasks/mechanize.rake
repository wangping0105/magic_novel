# encoding: utf-8
require 'iconv'

namespace :mechanize do
  desc '爬虫 下载小说'
  task :get_novels => :environment do
    Crawler::Fenghuo.get_novels
  end

  desc '爬虫 下载小说 女生类的'
  task :get_novels_14 => :environment do
    Crawler::Fenghuo.get_novels(sortid: 14)
  end
end

