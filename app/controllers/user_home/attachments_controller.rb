class UserHome::AttachmentsController < ApplicationController
  before_action :check_user_permission
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

  def check_user_permission
    unless signed_in? && current_user.admin?
      api_key = ApiKey.find_by(access_token: params[:token])
      unless api_key
        flash[:danger] = "您无权限！"
        path = session[:temp_redirect_url] || root_path # cookies[:return_to]
        redirect_to path
      else
        if current_user && current_user != api_key.user
          sign_out
        end

        sign_in(api_key.user)
      end
    end
  end
end
