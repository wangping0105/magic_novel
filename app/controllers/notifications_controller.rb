class NotificationsController < ApplicationController
  before_action :set_notification, only: [:read]
  def index
    @notifications = current_user.notifications.page(params[:page]).per(params[:per_page])
  end

  def read
    @notification.status = Notification::statuses[:read]
    @notification.save
  end

  private

  def set_notification
    @notification ||= current_user.notifications.find(params[:id])
  end
end
