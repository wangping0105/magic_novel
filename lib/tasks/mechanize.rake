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

  # cap production deploy:runrake task=mechanize:update_books
  # rake mechanize:update_books
  desc '爬虫 更新全部小说'
  task :update_books => :environment do
    Crawler::Fenghuo.update_books
  end

  # cap production deploy:runrake task=mechanize:update_books
  # rake mechanize:update_books
  desc '爬虫 更新 fulibus'
  task :update_books => :environment do
    Crawler::Fulibus.get_posts
  end
end

