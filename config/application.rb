require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MagicNovel
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.time_zone = 'Beijing'
    config.i18n.available_locales = [:"zh-CN", :zh, :en]
    config.i18n.default_locale = "zh-CN"
    # config.active_record.default_timezone = :local didnot reconmned

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    require_relative '../app/services/app_settings'
    config.cache_store = :redis_store, {
        host: AppSettings.redis.host,
        port: AppSettings.redis.port,
        db: AppSettings.redis.cache_db,
        password: AppSettings.redis[:password],
        expires_in: 2.days
    }
  end
end

# change
module ActiveSupport
  class TimeWithZone
    def to_s(format = :default)
      if format == :db
        utc.to_s(format)
      elsif formatter = ::Time::DATE_FORMATS[format]
        formatter.respond_to?(:call) ? formatter.call(self).to_s : strftime(formatter)
      else
        "#{time.strftime("%Y-%m-%d %H:%M")}"
      end
    end
  end
end
