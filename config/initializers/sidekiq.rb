# sidekiq
require 'sidekiq/web'


Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]
Sidekiq::Web.set :sessions, Rails.application.config.session_options
Sidekiq::Web.class_eval do
  use Rack::Protection, origin_whitelist: ['https://www.block-lian.com'] # resolve Rack Protection HttpOrigin
end

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == 'sidekiqadmin' && password == '5529d99a'
end if Rails.env.production?
