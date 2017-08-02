class UserHome::UsersController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :store_location
  def index

  end

  def show
    @user = User.find(params[:id])

  end

  def update
    @user = User.find(params[:id])
    authorize @user, :update?

    @user.assign_attributes(update_params)
    @user.save
  end

  private

  def update_params
     params.require(:user).permit(:name, :email, :phone)
  end
  
end
