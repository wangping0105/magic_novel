class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])

  end

  def update
    @user = User.find(params[:id])
    authorize @user, :update?
    @user.update_attributes(update_params)
  end

  private

  def update_params
     params.require(:user).permit(:name)
  end
  
end
