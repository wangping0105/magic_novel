class SendMsgToQqWorker
  include Sidekiq::Worker

  def perform(id)
    notification = Notification.find(id)
    content = notification.title + "\n" + notification.body
    FayeClient.send_message("/notifications/send_msg_to_qq", {notification:{content: content}})
  end
end