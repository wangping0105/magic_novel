source 'https://rubygems.org'
# source 'https://gems.ruby-china.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.1'
gem 'mysql2', '~> 0.4.9'
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
gem 'jquery-validation-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt'
#增加一个权限认证的机制
gem 'pundit'

# gem "sinatra-activerecord"
# API 调用频率限制(Rate Limit)
# 我们使用 redis-throttle 来实现这个功能。
gem 'redis-throttle', git: 'git://github.com/andreareginato/redis-throttle.git'

# 图形验证码
gem 'rucaptcha'
# 软删除
gem 'paranoia'
#enum 的一个帮助gem
gem 'acts_as_enum'

gem 'ruby-pinyin'

gem 'sidekiq'
# 地理位置相关的处理
gem 'geocoder'
# param! 参数检测
gem 'rails_param'
# web请求 Ruby Class提供快速Web服务，封装了大量的访问Web的类，是一个简单的HTTP / REST客户端库
gem 'whenever', require: false

gem 'httparty'
# https://github.com/Macrow/rails_kindeditor
# gem 'rails_kindeditor'
# web Crawler 爬虫
gem 'mechanize'
# markdown
gem 'redcarpet'
gem 'coderay'

gem "iconv"
# emoji表情
gem 'emojimmy'
# To use debugger 调试
# 我自己的一个gem
gem 'alidayu_sms'
gem 'puma', '3.7.0'
# 时间统计
gem 'rack-mini-profiler'
gem 'request_store'

# memberchche
gem 'dalli', '~> 2.7.4', :platforms => :ruby
gem 'friendly_id'

gem "bullet", :group => "development"

gem 'react-rails'

gem 'mini_magick'

gem 'rest-client'

gem 'settingslogic'

gem "redis-rails"

gem 'ledermann-rails-settings'

gem 'newrelic_rpm'

gem 'paperclip'

gem 'omniauth-github'
gem 'rails_admin'

group :development do
  gem 'rspec-rails'
  gem 'pry-remote'
  gem 'pry-nav'
  gem 'pry-rails'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'thin'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code. Read more: https://github.com/rails/web-console
  gem 'web-console'

  # The Listen gem listens to file modifications and notifies you about the changes. Read more: https://github.com/guard/listen
  gem 'listen', '~> 3.0.5'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Makes spring watch files using the listen gem. Read more: https://github.com/jonleighton/spring-watcher-listen
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Better error page for Rack apps. Read more: https://github.com/charliesome/better_errors
  # gem 'better_errors', '2.1.1'

  # Retrieve the binding of a method's caller in MRI 1.9.2+. Read more: https://github.com/banister/binding_of_caller
  gem 'binding_of_caller', '0.7.2'

  # Capistrano: A deployment automation tool built on Ruby, Rake, and SSH. Read more: https://github.com/capistrano/capistrano
  gem 'capistrano', '~> 3.5'

  # RVM support for Capistrano v3: https://github.com/capistrano/rvm
  gem 'capistrano-rvm'

  # Puma integration for Capistrano https://github.com/seuros/capistrano-puma
  gem 'capistrano3-puma'

  # Bundler support for Capistrano 3.x https://github.com/capistrano/bundler
  gem 'capistrano-bundler', '~> 1.1.4'

  # Rails specific tasks for Capistrano v3: https://github.com/capistrano/rails
  gem 'capistrano-rails'

  gem 'capistrano-sidekiq'

  # Patch-level verification for Bundler. Read more: https://github.com/rubysec/bundler-audit
  gem 'bundler-audit', '0.5.0'
end

# Use unicorn as the app server
group :production do
  gem 'god'
end
