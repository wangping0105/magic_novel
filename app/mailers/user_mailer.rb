class UserMailer < ApplicationMailer
  default from: "15921076830@163.com"

  def hello_world
    send_mail({
                  to: '525399584@qq.com',
                  subject: "Welcome to My Awesome Site"
              })
  end

  # UserMailer.send_auth_code("222222", '1291999046@qq.com').deliver_later
  def send_auth_code(code, email)
    @code = code
    send_mail({ to: email, subject: "注册验证码 -- 魔书网"})
  end

end
