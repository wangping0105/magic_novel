class AlidayuSms
  require 'net/http'

  class << self
    AppKey = 23304964
    AppScrect = '12b083a7c5e89ce3093067ddd65c4b5a'
    PostUrl = 'http://gw.api.taobao.com/router/rest'

    # 注册验证码
    def registered_verification_code(code, _phones, product = '魔书网', _extend = '')
      _sms_free_sign_name = '注册验证'
      _sms_template_code = 'SMS_5045503'

      standard_send_msg(code, product, _phones, _extend, _sms_free_sign_name, _sms_template_code)
    end

    def login_verification_code(code, _phones, product = '魔书网', _extend = '')
      _sms_free_sign_name = '登录验证'
      _sms_template_code = 'SMS_5045505'

      standard_send_msg(code, product, _phones, _extend, _sms_free_sign_name, _sms_template_code)
    end

    def standard_send_msg(code, product, _phones, _extend, _sms_free_sign_name, _sms_template_code)
      _sms_param = "{'code':'#{code}','product':'#{product}'}"

      _timestamp = Time.now.strftime("%F %T")
      options = {
        app_key: AppKey,
        format: 'json',
        method: 'alibaba.aliqin.fc.sms.num.send',
        partner_id: 'apidoc',
        sign_method: 'md5',
        timestamp: _timestamp,
        v: '2.0',
        extend: _extend,
        rec_num: _phones,
        sms_free_sign_name: _sms_free_sign_name,
        sms_param: _sms_param,
        sms_template_code: _sms_template_code,
        sms_type: 'normal'
      }
      options = sort_options(options)

      md5_str = 加密(options)
      response = post(PostUrl, options.merge(sign: md5_str))
      puts "发送成功！phones: #{_phones}, #{_sms_param}"
      response
    end

    def sort_options(**arg)
      arg.sort_by{|k,v| k}.to_h
    end

    def 加密(**arg)
      _arg = arg.map{|k,v| "#{k}#{v}"}
      md5("#{AppScrect}#{_arg.join("")}#{AppScrect}").upcase
    end

    def md5(arg)
      Digest::MD5.hexdigest(arg)
    end

    def post(uri, options)
      response = ""
      url = URI.parse(uri)
      Net::HTTP.start(url.host, url.port) do |http|
        req = Net::HTTP::Post.new(url.path)
        req.set_form_data(options)
        response = http.request(req).body
      end
      JSON(response)
    end
  end
end