class User < ActiveRecord::Base
  before_create :generate_authentication_token
  has_secure_password
  has_many :microposts

  acts_as_paranoid

  validates_uniqueness_of :email, conditions: -> { paranoia_scope }, allow_nil: true, allow_blank: true

  TEAVHER_URL = "/assets/guest.jpg"

  def generate_authentication_token
    loop do
      self.authentication_token = SecureRandom.base64(64)
      break if !User.find_by(authentication_token: authentication_token)
    end
  end
  
 def self.new_authentication_token
    SecureRandom.urlsafe_base64
  end
  
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def admin?
    if self.admin
      return true
    end
    false
  end
  private
    def create_authentication_token
      self.authentication_token = User.encrypt(User.authentication_token)
      #self.avatar_url = TEAVHER_URL
      #self.status = 0
    end
  

end
