# encoding: utf-8
require 'iconv'

namespace :mechanize do
  desc '爬虫 下载小说'
  task :get_novels => :environment do
    Crawler::Fenghuo.get_novels
  end
end

