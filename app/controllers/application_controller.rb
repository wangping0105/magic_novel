class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :default_page_title, :notification_count, :store_location
  before_action do
    if current_user && current_user.admin? && Rails.env.development?
      # Rack::MiniProfiler.authorize_request
    end
  end
  before_action :set_locale

  include SessionsHelper
  include UtilsHelper
  include Commonable

  attr_accessor :save_url

  def default_page_title
    @page_title ||= "魔书网"
    params[:per_page] ||= 30
  end

  def set_page_title(title)
    @page_title = "#{title} - 魔书网"
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
    relation = relation.page(params[:page]).per_page(params[:per_page])
    relation
  end

  def admin_authority?(user = current_user)
    unless user && user.admin?
      render :file => "#{Rails.root}/public/no_auth", :layout => false, :status => :not_found
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def set_title(title)
    "#{title}-魔书网"
  end

  def get_lastest_chapter
    if current_user.present?
      @lastest_chapter = RequestLog.where(user: current_user.id).order(updated_at: :desc).first.try(:book_chapter)
    end
  end

  protected
  def markdown(text)
    options = {
      :autolink => true,
      :space_after_headers => true,
      :fenced_code_blocks => true,
      :no_intra_emphasis => true,
      :hard_wrap => true,
      :strikethrough =>true
    }
    text = text.gsub("script>", "fuck>")
    Markdown.new(text).to_html
  end

  class HTMLwithCodeRay < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code, language).div(:tab_width=>2)
    end
  end
end
