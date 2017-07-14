class User	
  include Mongoid::Document
  include Mongoid::Timestamps
  field :provider, type: String
  # field :uid, type: String 
  # field :state, type: String
  field :oauth_token, type: String 
  field :oauth_expires_at, type: Datetime

  def self.from_omniauth(auth)
  	binding.pry
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
  		binding.pry
      user.provider = auth.provider
      user.oauth_token = auth.credentials.code
      # user.uid = auth.uid
      # user.name = auth.info.name
      # user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

end
