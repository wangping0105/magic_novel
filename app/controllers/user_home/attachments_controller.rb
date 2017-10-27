class UserHome::AttachmentsController < ApplicationController
  before_action :authenticate_admin_user!
  skip_before_action :store_location

  def index
    @attachments = current_user.attachments.page(params[:page]).order(id: :desc)
  end

  def create
    @attachment = current_user.attachments.new
    if file_is_image?
      @attachment.image = params[:file]
    else
      @attachment.file = params[:file]
    end

    if params[:file] && @attachment.save
      redirect_to user_home_attachments_path
    else
      flash[:danger] = "文件不能为空" unless params[:file]
      redirect_to user_home_attachments_path
    end
  end

  private

  def file_is_image?
    params[:file] && (params[:file].try(:content_type) =~ /\Aimage\/.*\z/).present?
  end
end
