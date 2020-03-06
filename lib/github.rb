require 'omniauth-oauth2'
require "./app/models/setting"
module OmniAuth
  module Strategies
    # @param [String] client_id the client_id value
    # @param [String] client_secret the client_secret value
    # @param [Hash] opts the options to create the client with
    # @option opts [String] :site the OAuth2 provider site host
    # @option opts [String] :redirect_uri the absolute URI to the Redirection Endpoint for use in authorization grants and token exchange
    # @option opts [String] :authorize_url ('/oauth/authorize') absolute or relative URL path to the Authorization endpoint
    # @option opts [String] :token_url ('/oauth/token') absolute or relative URL path to the Token endpoint
    # @option opts [Symbol] :token_method (:post) HTTP method to use to request token (:get or :post)
    # @option opts [Symbol] :auth_scheme (:basic_auth) HTTP method to use to authorize request (:basic_auth or :request_body)
    # @option opts [Hash] :connection_opts ({}) Hash of connection options to pass to initialize Faraday with
    # @option opts [FixNum] :max_redirects (5) maximum number of redirects to follow
    # @option opts [Boolean] :raise_errors (true) whether or not to raise an OAuth2::Error

    class Github < OmniAuth::Strategies::OAuth2
      option :client_options, {      
        :site => "https://api.github.com",
        :authorize_url => "https://github.com/login/oauth/authorize",
        :token_url => "https://github.com/login/oauth/access_token"
      }

      uid{ raw_info['id'] }

      info do
        {
            :name => raw_info['name'],
            :email => raw_info['email']
        }
      end

      extra do
        {
            'raw_info' => raw_info
        }
      end


      def raw_info
        p 111123213
        @raw_info ||= access_token.get("/user").parsed
      end
    end
  end
end

# 遇到的几个问题
# 没有主意 site 地址是 api.
