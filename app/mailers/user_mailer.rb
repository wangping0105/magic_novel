class UserMailer < ApplicationMailer
  default from: "15921076830@163.com"

  def hello_world
    send_mail({
                  to: '525399584@qq.com',
                  subject: "Welcome to My Awesome Site"
              })
  end

end
