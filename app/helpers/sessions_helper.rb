module SessionsHelper
  
  def sign_in(user)
    authentication_token = User.new_authentication_token
    cookies.permanent[:authentication_token] = authentication_token
    user.update_attribute(:authentication_token,User.encrypt(authentication_token))
    self.current_user = User.encrypt(authentication_token)
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    authentication_token = User.encrypt(cookies[:authentication_token])
    @current_user ||= User.find_by(authentication_token: authentication_token)
  end

  def current_author
    return Author.create(user_id: current_user.id, name: current_user.name) unless current_user.author.present?
    @current_author ||= current_user.author
  end

  def redirect_back_or(default)
    redirect_to (session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
      session[:return_to] = request.fullpath if request.get?
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    current_user.update_attribute(:authentication_token,
      User.encrypt(User.new_authentication_token))
    self.current_user = nil
    cookies.delete(:authentication_token)
  end

  def check_authority
    if !current_user.nil? && !current_user.status
      return true
    end
    false
  end

  def authenticate_user!
    unless signed_in?
      flash[:error] = "您无访问权限，请先登录！"
      path = (session[:return_to] || root_path)
      redirect_to root_path
    end
  end

end
