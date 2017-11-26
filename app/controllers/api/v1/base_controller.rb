class Api::V1::BaseController < ActionController::Base
  include Api::Rescueable
  include Api::Authenticateable
  include Api::DeviceDetectable
  include Commonable

  helper_method :current_user
  helper_method :version_code
  before_action :authenticate_referer!, :authenticate_app!, :authenticate!
  before_action :cors_preflight_check
  after_action :cors_set_headers

  protected

  def set_default_page_params
    params[:page] ||= 1
    params[:per_page] ||= Kaminari.config.default_per_page
  end

  def normal_render(code = 0, data = nil)
    _result = {code: code}
    _result = _result.merge(data: data) if data.present?
    render json: _result
  end

  def render_json_data(data)
    render json: { code: 0, data: data }
  end

  def page_options( data)
    type = data.klass.name.underscore.pluralize

    {
      type => data.map(&:as_json),
      page: params[:page],
      per_page: params[:per_page],
      total_count: data.total_count
    }
  end
end
