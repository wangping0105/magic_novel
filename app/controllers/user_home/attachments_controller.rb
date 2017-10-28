class UserHome::AttachmentsController < ApplicationController
  before_action :check_user_permission
  skip_before_action :store_location

  def index
    @user ||= current_user
    @attachments = @user.attachments.page(params[:page]).order(id: :desc)
  end

  def create
    @user ||= current_user
    @attachment = @user.attachments.new(note: params[:note])
    if file_is_image?
      @attachment.image = params[:file]
    else
      @attachment.file = params[:file]
    end

    unless params[:file] && @attachment.save
      flash[:danger] = "文件不能为空" unless params[:file]
    end

    redirect_to user_home_attachments_path(token: params[:token])
  end

  private

  def file_is_image?
    params[:file] && (params[:file].try(:content_type) =~ /\Aimage\/.*\z/).present?
  end

  def check_user_permission
    unless signed_in? && current_user.admin?
      api_key = ApiKey.find_by(access_token: params[:token])
      @user = api_key.user
      unless api_key && @user && @user.admin?
        flash[:danger] = "您无权限！"
        path = session[:temp_redirect_url] || root_path # cookies[:return_to]
        redirect_to path
      end
    end
  end
end
