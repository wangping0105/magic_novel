class SessionsController < ApplicationController
  layout 'layouts/sessions'
  def index
    @user = User.new
  end

  def create
    @user = User.find_by(email: create_params[:email])
    if @user && @user.authenticate(create_params[:password])
      self.current_user = @user
      flash[:success] = '登录成功'
      redirect_to root_path
    else
      flash[:error] = '账户密码不正确，请重试!'
      render 'index'
    end
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
