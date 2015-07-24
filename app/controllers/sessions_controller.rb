class SessionsController < ApplicationController
  skip_before_action :store_location
  layout 'layouts/sessions'
  def index
    @user = User.new
  end

  def create
    @user = User.find_by(email: create_params[:email])
    if @user && @user.authenticate(create_params[:password])
      sign_in(@user)
      flash[:success] = '登录成功'
    else
      flash[:error] = '账户密码不正确，请重试!'
    end
    redirect_back_or root_path
  end

  def signout
    sign_out
     flash[:success] = '退出成功'
    redirect_back_or root_path
  end

  private

  def create_params
    params.require(:user).permit(:email, :password)
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
