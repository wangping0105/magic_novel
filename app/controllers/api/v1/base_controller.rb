class Api::V1::BaseController < ActionController::Base
  include Api::Rescueable
  include Api::Authenticateable
  include Api::DeviceDetectable

  helper_method :current_user
  helper_method :version_code
  before_action :authenticate_referer!, :authenticate_app!, :authenticate!

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
end
