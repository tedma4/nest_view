class User	
  include Mongoid::Document
  include Mongoid::Timestamps
  attr_accessor :password
  before_save :encrypt_password
  # User Data
  field :name, type: String
  # Email
  field :email, type: String
  validates_uniqueness_of :email, on: [:create]
  validates_uniqueness_of :email, on: [:update], :if => :email_changed
  # Password
  validates_presence_of :password, :email, :on => :create
  validates_length_of :password, minimum: 8, maximum: 16, on: [:create]
  validates_length_of :password, minimum: 8, maximum: 16, on: [:update], :if => :password_changed

  field :encrypted_password, type: String, default: ""
  field :salt, type: String, default: ""
  # Oauth data
  field :provider, type: String
  field :oauth_token, type: String 
  field :oauth_expires_at, type: DateTime

  def self.from_omniauth(auth, session)
    where(provider: auth.provider).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.name = session[:user]["name"] if session[:user]
      user.email = session[:user]["email"] if session[:user]
      user.password = session[:user]["password"] if session[:user]
      user.save!
    end
  end

  def nest_data
    begin
    url = "https://developer-api.nest.com/"
    headers = {
      "Content-Type":  "application/json",
      "Authorization": "Bearer #{self.oauth_token}"
    }
    res = HTTParty.get(url, :headers => headers, follow_redirects: true)
    nest_user = JSON.parse res.body 
    nest_user["user_id"] = self.id.to_s
    nest_user
  rescue 
    false
  end
  end

  def authenticate(password)
    pass = BCrypt::Engine.hash_secret(password, self.salt)
    self.encrypted_password == pass
  end

  def build_user_hash
    user = {
      email: self.email,
      name: self.name
    }
    user
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
