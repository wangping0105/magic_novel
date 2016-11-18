root_path = Rails.root

APP_CONFIG = HashWithIndifferentAccess.new({})
if File.exist?(root_path.join('config/cross_sites.yml'))
  CROSS_SITES = HashWithIndifferentAccess.new(YAML.load_file(root_path.join('config/cross_sites.yml'))[Rails.env] || {})

  APP_CONFIG[:cross_sites] = CROSS_SITES
end