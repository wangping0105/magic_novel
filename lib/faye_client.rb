class FayeClient
  class << self
    cattr_accessor :auth_token

    self.auth_token ||= "magic_novel" #App.find_by(app_name: "crm_push").try(:access_token) rescue nil

    # base method push message to push server
    def push_to_socket(message)
      message[:auth_token] ||= auth_token
      uri = URI.parse("#{CROSS_SITES[:faye_push][:host]}/faye")

      begin
        socket = Faye::Client.new(uri)
        socket.send(message.to_json,0)
        socket.close
        socket = nil
      rescue => error
        Rails.logger.error("#{error.message}, when call #{__method__}")
      end
    end

    def push_socket_message(channel, params)
      push_to_socket({channel: channel, data: params})
    end


    def send_message_with_asnyc(channel, params)
      params[:auth_token] ||= auth_token
      message = {channel: channel, data: params}

      FayePushWorker.perform_async(message.to_json)
    end

    def send_message(channel, params)
      fiber = Fiber.new do
        params[:auth_token] ||= auth_token
        message = {channel: channel, data: params}
        uri = URI.parse("#{CROSS_SITES[:faye_push][:host]}/faye")

        Net::HTTP.post_form(uri, message: message.to_json)
      end

      fiber.resume
    end
  end
end
# FayeClient.send_message("/notifications/broadcast", {text: "niday2323e"})
# FayeClient.send_message_with_asnyc("/notifications/broadcast", {text: "niday2323e"})
# FayeClient.send_message("/notifications/f93dc25bbf55fc630501689de3f960e761", {text: "niday2323e"})
 # FayeClient.push_socket_message("/notifications/broadcast", {text: "niday2323e"}) # faye required
