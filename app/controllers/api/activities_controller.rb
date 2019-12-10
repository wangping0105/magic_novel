class Api::ActivitiesController < ApplicationController
  protect_from_forgery except: :index

  def index
    activity = Activity.find_by(source: :default, url: params[:url])

    if activity
      render json: activity.slice(:id, :url, :count)
    else
      render json: {error: "not found", message: 'url不存在数据'}, status: 404
    end
  end

  def record
    if params[:id].present?
      activity = Activity.find(params[:id])
      activity.with_lock do
        activity.count += 1
        activity.save!
      end

      render layout:false
    else
      render json: {error: "invalid arg", message: '请传入正确的id'}, status: 400
    end
  end
end
