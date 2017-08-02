module SessionsHelper
  # = 高并发建议用Cookie吧，主要是效率高，操作方便，对服务器造成的压力会小些，这个注意加密及安全
  # = 一些安全要求高的功能可以使用Session
  # = 使用memcahed来保存session, 性能跟效率还是很高的, mencache还可以使用多台服务器, 既能共享SESSION, 又能集群减低压力.
  def sign_in(user)
    unless session[:authentication_token].present?
      authentication_token = User.new_authentication_token
      session[:authentication_token] = authentication_token
      session[:expires_at] = 30.days
      # 单浏览器登录校验
      user.update_attribute(:authentication_token,User.encrypt(authentication_token))
    else
      authentication_token = session[:authentication_token]
    end

    self.current_user = User.encrypt(authentication_token)
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    return unless session[:authentication_token]
    authentication_token = User.encrypt(session[:authentication_token])
    @current_user ||= User.find_by(authentication_token: authentication_token)
    session.delete(:authentication_token) if @current_user.nil?
    @current_user
  end

  def current_author
    if current_user.present?
      return Author.create(user_id: current_user.id, name: current_user.name) unless current_user.author.present?
      @current_author ||= current_user.author
    else
      nil
    end
  end

  def redirect_back_or(default)
    redirect_to (cookies[:return_to] || default)
    cookies.delete(:return_to)
  end

  def store_location
    cookies[:return_to] = request.fullpath if request.get? && !request.fullpath.match(/api/)
  end

  def signed_in?
    current_user.present?
  end

  def sign_out
    if current_user
      current_user.update_attribute(:authentication_token, User.encrypt(User.new_authentication_token))
      self.current_user = nil
      session.delete(:authentication_token)
    end
  end

  def check_authority
    if !current_user.nil? && !current_user.status
      return true
    end
    false
  end

  def authenticate_user!
    unless signed_in?
      flash[:danger] = "您无访问权限，请先登录！"
      path = root_path # cookies[:return_to]
      redirect_to path
    end
  end

end
