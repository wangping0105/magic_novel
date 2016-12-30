class UserDevice < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization

  enum platform: [:igetui, :apns]

  enum device_platform: [:ios, :android]

  acts_as_paranoid
end
