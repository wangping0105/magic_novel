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

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def set_title(title)
    "#{title}-魔书网"
  end

  def save_request_logs(last_chapter_id: nil)
    ip = request.remote_ip

    request = RequestLog.where(ip: ip).last
    if request && request.time_diff_in
      request.with_lock do
        request.count += 1
        request.last_chapter_id = last_chapter_id if last_chapter_id.present?

        request.save!
      end
      request.count = request.count += 1
    else
      RequestLog.create(ip: ip, user_id: current_user.try(:id), last_chapter_id: last_chapter_id, count: 1)
    end
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
