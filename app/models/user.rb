class User < ActiveRecord::Base
  before_create :generate_authentication_token
  has_secure_password
  has_many :microposts

  def generate_authentication_token
    loop do
      self.authentication_token = SecureRandom.base64(64)
      break if !User.find_by(authentication_token: authentication_token)
    end
  end

  #理由以下几点:
  #需要有一个方法帮助用户重置 authentication token, 而不仅仅是在创建用户时生成 authenticeation token；
  #如果用户的 token 被泄漏了，我们可以通过 reset_auth_token! 方法方便地重置用户 token;
  def reset_auth_token!
    generate_authentication_token
    save
  end

end
