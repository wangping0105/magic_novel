class AppSettings < Settingslogic
  source "#{Rails.root}/config/services.yml"
  namespace Rails.env
end
