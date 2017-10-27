class UserHome::AttachmentsController < ApplicationController
  before_action :authenticate_admin_user!
  skip_before_action :store_location

  def index
    @attachments = current_user.attachments.page(params[:page]).order(id: :desc)
  end

  def new
    @attachment = current_user.attachments.new
  end

  def create
    @attachment = current_user.attachments.new
    @attachment.file = params[:file]
    if @attachment.save
      redirect_to user_home_attachments_path
    else
      render 'new'
    end
  end

  private
  
end
