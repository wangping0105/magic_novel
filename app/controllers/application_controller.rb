class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :default_page_title, :notification_count, :store_location
  before_action do
    if current_user && current_user.admin? && Rails.env.development?
      Rack::MiniProfiler.authorize_request
    end
  end
  include SessionsHelper
  include UtilsHelper

  attr_accessor :save_url

  def default_page_title
    @page_title = "魔书网"
  end

  def notification_count
    if current_user
      @notification_count ||= current_user.notifications.unread.count
    end
  end

  def raise_error(flag, message)
    if flag
      raise StandardError.new(message)
    end
  end

  def simple_error_message(entity)
    entity.errors.messages.map{|k,v| v.join(":")}.join(",")
  end

  def filter_page(relation)
    relation = relation.page(params[:page]).per(params[:per_page])
    relation
  end

  def admin_authority?(user = current_user)
    unless user && user.admin?
      render :file => "#{Rails.root}/public/no_auth", :layout => false, :status => :not_found
    end
  end

  def fetch_memberchace(_cache_key, expires_in, &block)
    return yield if $dalli_store.nil?

    $dalli_store.read(_cache_key) || $dalli_store.fetch(_cache_key, expires_in: expires_in) do
      puts "存入membercache!"
      yield
    end
  end
end
