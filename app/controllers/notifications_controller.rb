class NotificationsController < ApplicationController
  def index
    @notifications = Notification.page(params[:page]).per(params[:per_page])
  end
end
