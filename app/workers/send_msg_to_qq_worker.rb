class SendMsgToQqWorker
  include Sidekiq::Worker

  def perform(id)
    notification = Notification.find(id)
    content = notification.title + "\n" + notification.body
    user = notification.user
    #TODO remove faye and replace it
    # FayeClient.send_message("/notifications/#{user.api_key.access_token}#{user.id}", { notification: { title: notification.title } }) if user
    # FayeClient.send_message("/notifications/send_msg_to_qq", {notification:{content: content}})
  end
end