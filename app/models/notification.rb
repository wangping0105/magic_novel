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

  validates_presence_of :title, message:'标题不能为空!'
  validates_presence_of :body, message:'内容不能为空!'

  before_create do
    self.category ||= Notification::categories[:system]
    self.status ||= Notification::statuses[:unread]
    self.receive_platform ||= Notification::receive_platforms[:all_platform]
  end

  def as_json
    {
      id: id,
      title: title,
      body: body.to_s,
      category: category.to_s,
      status: status.to_s,
      notify_type: notify_type.to_s,
      created_at: created_at.to_s
    }
  end
end
