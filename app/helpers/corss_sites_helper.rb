module CorssSitesHelper
  def faye_push_token
    "magic_novel"
  end

  def faye_push_uri
    URI CROSS_SITES[:faye_push][:host] if CROSS_SITES[:faye_push][:host]
  end
end