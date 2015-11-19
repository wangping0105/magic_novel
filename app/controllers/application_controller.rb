class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :default_page_title,  :store_location
  include SessionsHelper
  include UtilsHelper

  attr_accessor :save_url

  def default_page_title
    @page_title = "魔书网"
  end


end
