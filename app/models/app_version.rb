class AppVersion < ActiveRecord::Base
  enum app_type: [ :android, :ios ]
  APP_TYPE = HashWithIndifferentAccess.new(I18n.t("enums.app_version.app_type"))

  enum upgrade: [:notice, :suggest, :force]
end
