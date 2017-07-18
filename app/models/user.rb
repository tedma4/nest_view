class User	
  include Mongoid::Document
  include Mongoid::Timestamps
  field :provider, type: String
  # field :uid, type: String 
  # field :state, type: String
  field :oauth_token, type: String 
  field :oauth_expires_at, type: DateTime

  def self.from_omniauth(auth)
    where(provider: auth.provider).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def nest_data
    url = "https://developer-api.nest.com/"
    headers = {
      "Content-Type":  "application/json",
      "Authorization": "Bearer #{self.oauth_token}"
    }
    res = HTTParty.get(url, :headers => headers, follow_redirects: true)
    JSON.parse res.body 
  end
end
