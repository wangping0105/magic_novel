class NotificationsController < ApplicationController
  before_action :set_notification, only: [:read]
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.order(id: :desc).page(params[:page]).per_page(params[:per_page])
  end

  def new
    @notifications = current_user.notifications.new
  end

  def create
    if params[:remind_at].present?
      target_time = Time.parse(params[:remind_at]) - Time.now
    end

    @notifications = current_user.notifications.new(notification_params)
    if @notifications.save && ( target_time.nil? || target_time>0)
      if params[:remind_at].present?
        target_time = Time.parse(params[:remind_at]) - Time.now
        SendMsgToQqWorker.perform_at(target_time, @notifications.id)
      else
        SendMsgToQqWorker.perform_async(@notifications.id)
      end
      redirect_to notifications_path
    else
      if target_time<0
        flash[:danger] = "推送时间不能小于当前时间"
      else
        flash[:danger] = @notifications.errors.full_messages
      end
      render 'new'
    end
  end

  def read
    @notification.status = Notification::statuses[:read]
    @notification.save
  end

  private

  def set_notification
    @notification ||= current_user.notifications.find(params[:id])
  end

  def notification_params
    params.require(:notification).permit(:title, :body)
  end
end
