module Api::DeviceDetectable
  extend ActiveSupport::Concern

  included do
    helper_method :android?, :ios?, :dingtalk?, :android_or_ios?, :device
  end

  def android?
    device == "android"
  end

  def ios?
    device == "ios"
  end

  def android_or_ios?
    android? || ios?
  end

  def device
    auth_params[:device].presence
  end
end
