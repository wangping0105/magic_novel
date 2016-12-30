module Api::Rescueable
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :rescue_all
    rescue_from EntityValidationError, with: :entity_validation_error
    rescue_from CommonError, with: :common_error
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :show_errors
  end

  private
  def entity_validation_error(e)
    log_error(e)
    render json: { code: ErrorCodes::INVALID_PARAMS, message: e.message, error: e.class.name.underscore }
  end

  def common_error(e)
    log_error(e)
    render json: { code: ErrorCodes::INVALID_PARAMS, message: e.msg, error: e.class.name.underscore }
  end

  def rescue_all(e)
    log_error(e)
    render json: { code: ErrorCodes::SERVER_ERROR, message: "抱歉~ 系统出错了，攻城狮们已经在修理了！", error: e.class.name.underscore, original_message: e.message }
  end

  def log_error(e)
    logger.error e.message
    e.backtrace.each do |message|
      logger.error message
    end
  end
end

