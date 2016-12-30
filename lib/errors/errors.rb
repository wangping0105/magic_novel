class AuthError < StandardError; end
class AuthLockError < StandardError; end

class InvalidAppError < StandardError; end
class UserAuthenticationError < StandardError; end

class SignupInvalidPhoneError < StandardError; end
class SignupInvalidCaptchaError < StandardError; end

class RecordNotFoundError < StandardError; end

class FailSmsError < StandardError; end

class TakeCommonCustomerError < StandardError; end

class UnauthorizedError < StandardError; end

class CommonExceedError < StandardError
  attr_accessor :code,:msg
  def initialize(msg, code)
    code = code
    msg = msg
  end
end

class EntityValidationError < StandardError
  attr_reader :record
  def initialize(record = nil)
    @record = record
  end

  def to_s
    return "" unless @record.present?
    return @record if @record.class == String
    # Customer.cache_enabled_custom_fields_by_organization(current_organization.id).detect{|c| c.name.eql?("address.email") }
    # =判断是否是有自定义字段的model
    if @record.class.respond_to? :enabled_custom_fields_by_organization
      @record.errors.messages.map{|k,v| "#{@record.custom_fields.detect{|c| c.name.eql?(k)}}#{v.join(":")}"}.join(",")
    else
      @record.errors.full_messages.join(",")
    end
  end
end

# 有可能被删除的对象，返回的数据
# 这样有利于app端的处理
class EntityAbnormal
  attr_accessor :abnormal_status, :abnormal_message
  def initialize(abnormal_status = 'deleted', abnormal_message = '该对象已经被删除')
    self.abnormal_status = abnormal_status
    self.abnormal_message = abnormal_message
  end

  def to_s
    {
      id: -1,
      abnormal_status: self.abnormal_status.to_s ,
      abnormal_message: self.abnormal_message.to_s
    }
  end
end
