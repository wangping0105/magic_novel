module CorssSitesHelper
  def faye_push_token
    "111111"
  end

  def faye_push_uri
    URI CROSS_SITES[:faye_push][:host] if CROSS_SITES[:faye_push][:host]
  end
end