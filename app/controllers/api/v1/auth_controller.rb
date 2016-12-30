class Api::V1::AuthController < Api::V1::BaseController
  skip_before_action :authenticate!

  def login
    param! :phone, String, required: true
    param! :password, String, required: true

    @user = User.find_by(phone: params[:phone])
    if @user && @user.authenticate(params[:password])
      render_json_data({
        id: @user.id,
        name: @user.name,
        email: @user.email,
        user_token: @user.api_key.access_token
      })
    else
      render json: { code: -1, message: "帐号或者密码错误" }
    end
  end

  # 发送验证码
  def send_verification_code
    param! :sms_type, String, required: true, in: ['sign_up', 'change_pwd']
    param! :phone, String, required: true

    code, phone = random_verification_code(6), params[:phone]

    sms = SmsCode.find_or_create_by(sms_type: SmsCode.sms_types[params[:sms_type]], phone: phone)
    sms.code = code
    if sms.save
      result = Alidayu::Sms.send("send_code_for_#{params[:sms_type]}", code, phone)
      if result['error_response'].present?
        render json: { code: -1,  message: result['error_response']['sub_msg'] }
      else
        render json: { code: 0}
      end
    else
      render json: { code: -1, message: "帐号或者密码错误" }
    end
  end

  # 注册
  def sign_up
    param! :phone, String, required: true
    param! :code, String, required: true
    param! :password, String, required: true

    code, phone = params[:code], params[:phone]

    sms = SmsCode.find_by(sms_type: SmsCode.sms_types[:sign_up], phone: phone, code: code)
    unless sms && sms.updated_at - 5.minutes <= Time.now
      raise SignupInvalidCaptchaError.new("验证码过期或无效")
    end

    User.transaction do
      if @user = User.create(phone: phone, password: params[:password], name: params[:name])
        render json: { code: 0 }
      else
        raise SignupInvalidPhoneError.new("该手机号已经存在")
      end
    end
  end

  def change_password
    param! :phone, String, required: true
    param! :code, String, required: true
    param! :password, String, required: true

    code, phone = params[:code], params[:phone]
    sms = SmsCode.find_by(sms_type: SmsCode.sms_types[:change_pwd], phone: phone, code: code)
    if sms && sms.updated_at - 5.minutes <= Time.now
        @user= User.find_by(phone: phone)
        if @user
          @user.update(password: params[:password])
        else
          render json: { code: -1, message: "用户不存在" }
        end
    else
      raise SignupInvalidCaptchaError.new("验证码过期或无效")
    end
  end

  # 直接验证码登录
  def code_login
    param! :phone, String, required: true
    param! :code, String, required: true

    code, phone = params[:code], params[:phone]
    @user = User.find_or_create_by(phone: phone)
    sms = @user.sms_codes.find_by(sms_type: SmsCode.sms_types[:signup], phone: phone, code: code)

    unless sms && sms.updated_at + 5.minute <= Time.now
      raise SignupInvalidCaptchaError.new("验证码过期或无效")
    end
  end

  def logout
    current_user.user_devices.destroy_all
    render json: { code: 0, data: {}}
  end

  def ping
    render json: { code: 0, message: "pong" }
  end

  private
  # 随机六位数验证码
  def random_verification_code(index)
    chars = ("0".."9").to_a
    code = ""
    1.upto(index) { |i| code << chars[rand(chars.size)] }
    return code
  end
end
