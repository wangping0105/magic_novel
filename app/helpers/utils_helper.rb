module UtilsHelper
  def standard_time(time = Time.now)
    return "" if time.nil?
    time.strftime("%F %T")
  end
end
