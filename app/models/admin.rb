class Admin
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :password
  before_save :encrypt_password
  # Email
  field :email, type: String, default: ""
  validates_uniqueness_of :email, on: [:create]
  validates_uniqueness_of :email, on: [:update], :if => :email_changed
  # Password
  validates_presence_of :password, :email, :on => :create
  validates_length_of :password, minimum: 8, maximum: 16, on: [:create]
  validates_length_of :password, minimum: 8, maximum: 16, on: [:update], :if => :password_changed

  field :encrypted_password, type: String, default: ""
  field :salt, type: String, default: ""
  # Admin
  field :name, type: String

  def authenticate(password)
    pass = BCrypt::Engine.hash_secret(password, self.salt)
    self.encrypted_password == pass
  end

  private
    def encrypt_password
      if password.present?
        self.salt = BCrypt::Engine.generate_salt
        self.encrypted_password = BCrypt::Engine.hash_secret(password, self.salt)
      end
    end

    def email_changed
      if email_changed?
        true
      else
        false
      end
    end

    def password_changed
      if password && BCrypt::Engine.hash_secret(password, self.salt) != self.encrypted_password
        true
      else
        false
      end
    end
end