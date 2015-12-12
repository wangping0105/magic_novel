#source 'https://rubygems.org'
source 'https://ruby.taobao.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
gem 'mysql2', '~> 0.3.18'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
#//分页
gem 'kaminari'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
#增加一个权限认证的机制
gem 'pundit'

gem "sinatra-activerecord"
# API 调用频率限制(Rate Limit)
# 我们使用 redis-throttle 来实现这个功能。
gem 'redis-throttle', git: 'git://github.com/andreareginato/redis-throttle.git'
# 图形验证码
gem 'rucaptcha'
# 软删除
gem 'paranoia', '~> 2.1.0'
#enum 的一个帮助gem
gem 'acts_as_enum'
#
gem 'ruby-pinyin', '~> 0.4.5'

gem 'sidekiq', '~> 3.4.1'

group :development, :test do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end
# https://github.com/Macrow/rails_kindeditor
gem 'rails_kindeditor'

gem 'mechanize'

gem "iconv", "~> 1.0.3"
# emoji表情
gem 'emojimmy'
# To use debugger 调试
group :development do
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-nav'
  # gem 'debugger'
  gem 'thin'
  gem "quiet_assets"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'rack-mini-profiler', require: false
end

# Use Capistrano for deployment 自动化部署
group :development do
  gem 'capistrano-rails', '~> 1.1.3'
  gem 'capistrano3-unicorn', '~> 0.2.1'
  # gem 'sepastian-capistrano3-unicorn', '~> 0.5.1'
  gem 'capistrano-rvm', '~> 0.1.2'
  gem 'capistrano-sidekiq'
end
