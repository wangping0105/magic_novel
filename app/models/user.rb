class User < ActiveRecord::Base
  before_create :generate_authentication_token
  has_secure_password
  has_one :author
  has_many :book_marks, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_one :api_key
  has_one :attachment, as: :attachmentable

  acts_as_paranoid
  validates_uniqueness_of :email, conditions: -> { paranoia_scope }, allow_nil: true, allow_blank: true
  validates_presence_of :name

  has_settings do |s|
    s.key :chapter_font, :defaults => { :color => 'FFFFFF', :font_size => '16'}
  end

  TEAVHER_URL = "/assets/guest.jpg"

  after_save do
    ApiKey.find_or_create_by(user: self)
  end

  def collection_books
    BookRelation.where(user_id: id, relation_type: BookRelation::COLLECTION)
  end

  def generate_authentication_token
    loop do
      self.authentication_token = SecureRandom.base64(64)
      break if !User.find_by(authentication_token: authentication_token)
    end
  end

  def readable_books(klass = Book)
    if admin?
      klass.all
    else
      klass.no_unline
    end
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

  def self.new_authentication_token
    SecureRandom.urlsafe_base64
  end

  def temp_access_token
    "user_#{self.id}_temp_access_token"
  end

  private
  def create_authentication_token
    self.authentication_token = User.encrypt(User.authentication_token)
    #self.avatar_url = TEAVHER_URL
    #self.status = 0
  end


end
