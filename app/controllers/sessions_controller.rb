class SessionsController < ApplicationController
  skip_before_action :store_location
  layout 'layouts/sessions'

  def index
    @user = User.new
  end

  def create
    puts auth_hash

    if auth_hash.present?
      @user = User.find_or_create_by(provider: params[:provider], provider_uid: auth_hash[:uid])
      @user.update(auth_hash[:info].to_h)
      sign_in(@user)
      flash[:success] = '登录成功'
    else
      login = params[:login].match(/w*@w*/) ? "email" : "phone"
      @user = User.find_by(login => params[:login])

      if @user && @user.authenticate(user_params[:password])
        sign_in(@user)
        flash[:success] = '登录成功'
      else
        flash[:danger] = '账户密码不正确，请重试!'
      end
    end

    redirect_back_or root_path
  end

  def new
    @user = User.new
  end

  def sign_up
    @user = User.new
    @user.assign_attributes(user_params)

    if verify_rucaptcha?(@user)
      if @user.save
        sign_in(@user)
        flash[:success] = '成功注册'
        @user.notifications.create(title: "欢迎你#{@user.name}", body: "欢迎来到魔书网，祝你阅读愉快！如有什么问题，欢迎去吐槽区吐槽再吐槽。")

        redirect_to root_path
      else
        flash[:error] = "注册失败,#{@user.errors.messages.map{|k,v| "#{k} #{v[0]}"}.join(",")}"
        render 'sessions/new'
      end
    else
      flash[:error] = "注册失败,验证码错误"
      render 'sessions/new'
    end
  end

  def signout
    sign_out
    flash[:success] = '退出成功'
    redirect_back_or root_path
  end

  def failure
    flash[:danger] = "登陆失败 #{params[:message]}"

    redirect_back_or root_path
  end

  protected

  def auth_hash
    @auth_hash ||= request.env['omniauth.auth']
  end

  private
  def user_params
    params.require(:user).permit(:email, :phone, :password, :name)
  end

  def redirect_or_back_to path
    if save_url
      path = save_url
      save_url = nil
    end
    redirect_to path
  end

  def save_require_url
    save_url = nil if request.url
  end

end
