class ApplicationMailer < ActionMailer::Base
  default from: "15921076830@163.com"

  # def confirm(email)
  #   subject    "激活'我的生活'账户"
  #   recipients email
  #   from       'xxxxxxxx@163.com'
  #   sent_on    Time.now

  #   body       "欢迎加入‘我的生活’，我们致力于更加方便的生活，请点击激活账户"
  # end

  # def welcome_email(user)
  #   @user = user
  #   @url  = 'http://example.com/login'
  #   mail(to: 'xxxxxxxx@163.com', subject: 'Welcome to My Awesome Site')
  # end

  def send_mail(params = {})
    mail(:subject => params[:subject], :to => params[:to], :date => Time.now) do |format|
      format.text
    end
  end
end
