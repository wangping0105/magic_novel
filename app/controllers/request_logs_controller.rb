class RequestLogsController < ApplicationController
  before_action :authenticate_user!

  def index
    @request_logs = RequestLog.includes(:user, book_chapter: :book).order(updated_at: :desc).page(params[:page]).per(params[:per_page])
  end
end
