class User < ActiveRecord::Base
  has_secure_password
  
  before_save :create_auth_token
  before_save { self.email = email.downcase }
  
  validates :username,
    presence: true,
    uniqueness: true

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,
    presence: true,
    uniqueness: true,
    format: { with: EMAIL_REGEX, message: "invalid format" }

  validates :password, 
    presence: true,
    length: { minimum: 6, maximum: 20 },
    allow_nil: true

  has_many :projects, dependent: :destroy
  has_many :issues, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum role: {
    admin: 1,
    pm: 2,
    reviewer: 3,
    user: 4
  }

  # is_admin? is_user?
  roles.each do |role, _|
    define_method :"is_#{role}?" do
      self.role == role
    end
  end

  def in_role?(role)
    self.role == role
  end

  def create_auth_token
    self.auth_token = Digest::SHA1.hexdigest([self.email, Time.now].join)
  end
end