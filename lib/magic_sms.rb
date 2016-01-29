class MagicSms
  require 'net/http'

  class << self
    # 注册验证码
    def registered_verification_code(code, _phones, product = '魔书网', _extend = '')
      options = {
        code: code, # 验证码
        phones: _phones,
        product: product, # 模板的product字段
        extend: _extend, # 公共回传参数，在“消息返回”中会透传回该参数；举例：用户可以传入自己下级的会员ID，在消息返回时，该会员ID会包含在内，用户可以根据该会员ID识别是哪位会员使用了你的应用
        sms_free_sign_name: "注册验证", # 短信签名
        sms_template_code: "SMS_5045503" # 短信模板
      }

      AlidayuSmsSender.new.batchSendSms(options)
    end

    def login_verification_code(code, _phones, product = '魔书网', _extend = '')
      options = {
        code: code, # 验证码
        phones: _phones,
        product: product, # 模板的product字段
        extend: _extend, # 公共回传参数，在“消息返回”中会透传回该参数；举例：用户可以传入自己下级的会员ID，在消息返回时，该会员ID会包含在内，用户可以根据该会员ID识别是哪位会员使用了你的应用
        sms_free_sign_name: "登录验证", # 短信签名
        sms_template_code: "SMS_5045505" # 短信模板
      }

      AlidayuSmsSender.new.batchSendSms(options)
    end
  end
end