class Notification < ActiveRecord::Base
  enum status: [:unread, :read, :expired] # 未读 已读 失效

  enum receive_platform: {all_platform: 0, pc_platform: 1, app_platform: 2, none_platform: 3}

  enum notify_type: {
         notify_create:                   0,
         notify_transfer:                 1,
         notify_assign:                   2,
         notify_update:                   3,
         notify_remind:                   4,
       }

  enum category: [:system, :personal] #系统公告, 个人信息
end
