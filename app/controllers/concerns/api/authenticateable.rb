module Api::Authenticateable
  # controller and view
  extend ActiveSupport::Concern

  included do
    helper_method :version_code
  end

  private
  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'Authorization,Origin,X-Requested-With,Content-Type,Accept,x-csrf-token'
      headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'text/plain'
    end
  end

  def cors_set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = '1728000'
  end

  def authenticate_referer!

    return true if android_or_ios? || auth_params[:skip_referer].present?

    if request.referer.present? && request.referer !~ /localhost|192\.168/
      raise AuthError.new('非法请求')
    end
  end

  def authenticate_app!
    raise InvalidAppError.new("app的access_token不对") unless current_app
  end

  def authenticate!
    unless current_user
      key = "orgin_token_#{auth_params[:user_token]}"
      change_reason = Rails.cache.read(key) || "您的登录已经过期，请重新登录！"

      logger.error "invalid user_token, auth_params #{auth_params.as_json}"
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
    return @auth_params if @auth_params
    _headers = request.headers.env
    params[:user_token] ||= _headers["HTTP_USER_TOKEN"]
    params[:version_code] ||= _headers["HTTP_VERSION_CODE"]

    @auth_params = params

    @auth_params
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
