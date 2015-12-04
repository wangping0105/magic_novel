class RecordNotFoundError < StandardError; end

class CommonError < StandardError
  attr_accessor :code,:msg
  def initialize(msg)
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
