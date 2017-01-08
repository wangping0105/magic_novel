module Api::Authenticateable
  # controller and view
  extend ActiveSupport::Concern

  included do
    helper_method :version_code
  end

  private
  def authenticate_referer!
    return true if android_or_ios? || auth_params[:skip_referer].present?

    if request.referer.present? && request.referer !~ /ikcrm|localhost|192\.168/
      raise AuthError.new('非法请求')
    end
  end

  def authenticate_app!
    raise InvalidAppError.new("app的access_token不对") unless current_app
  end

  def authenticate!
    unless current_user
      key = "orgin_token_#{auth_params[:user_token]}"
      change_reason = $redis.get(key) || "您的登录已经过期，请重新登录！"

      logger.error "invalid user_token, auth_params #{auth_params}"
      raise UserAuthenticationError.new(change_reason)
    end

    RequestStore.store[:current_user] = current_user
  end

  def current_user
    return @current_user if defined?(@current_user)
    token = ApiKey.find_by(access_token: auth_params[:user_token])
    if token
      @current_user = User.find_by(id: token.user_id)
    end
  end

  def current_app
    @current_app ||= "magicbook"
  end

  def current_user_device
    current_user.user_devices.order("id desc").first if current_user.present?
  end

  def auth_params
    @auth_params ||= begin
      token, options = token_and_options(request)
      return params unless options
      options[:user_token] = token
      options
    end
  rescue
    params
  end

  # 确保version_code都按 major.minor.patch 格式传递过来，并且不同客户端同一版本api确保值一致
  def version_code
    if auth_params[:version_code] == '30' || auth_params[:version_code] == '3.0'
      '3.0.0'
    else
      auth_params[:version_code]
    end
  end
end
