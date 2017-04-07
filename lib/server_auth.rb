class ServerAuth
  cattr_accessor :auth_token

  self.auth_token ||= "magic_novel"

  def incoming(message, callback)
    if message['channel'] !~ %r{^/meta/}
      # Get subscribed channel and auth token
      token = message['data'] && message['data']['auth_token']

      unless token and token.eql? self.auth_token
        message['error'] = 'Invalid auth token'
      end
    end
    callback.call(message)
  end
  # IMPORTANT: clear out the auth token so it is not leaked to the client
  def outgoing(message, callback)
    message['data'].delete('auth_token') if message['data'].is_a?(Hash)

    if message['ext'] && message['ext']['auth_token']
      message['ext'] = {}
    end
    callback.call(message)
  end
end
