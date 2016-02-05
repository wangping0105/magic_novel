if defined?(Dalli) and File.exist?("#{Rails.root}/config/dalli.yml")
  require "active_support/cache/dalli_store"

  dalli_config = YAML.load_file(Rails.root.join('config/dalli.yml'))[Rails.env]
  memcached_hosts = dalli_config['servers']
  dalli_options = dalli_config["options"].symbolize_keys

  $dalli_client = Dalli::Client.new *memcached_hosts, dalli_config["options"]
  $dalli_store = ActiveSupport::Cache::DalliStore.new(*memcached_hosts, dalli_config["options"])

  dalli_config["options"][:expires_in] = 365*24*3600
  $dalli_store_goal_type = ActiveSupport::Cache::DalliStore.new(*memcached_hosts, dalli_options)
end
