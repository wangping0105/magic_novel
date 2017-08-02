class UsersController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :store_location
  def index

  end

  def show
    @user = User.find(params[:id])

  end

  def update
    @user = User.find(params[:id])
    if @user.update(update_params)

      redirect_to user_home_users_path
    else
      render 'user_home/users/index'
    end
  end

  def user_settings
    cookies[:color] = params[:color] || 'FFFFFF'
    cookies[:font_size] = params[:font_size] || 14
    redirect_to book_book_chapter_path(params[:book_id], params[:book_chapter_id])
  end

  private

  def update_params
     params.require(:user).permit(:name, :email, :phone)
  end
  
end
