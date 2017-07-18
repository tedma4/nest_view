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

  def nest
    url = URI.parse('https://developer-api.nest.com/')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(url.to_s)
    req["Content-Type"] = "application/json"
    req["Authorization"] = "Bearer c.k4FCsfOcNz0DX1qssKhZ6GSCrKWECyrasXLDC0oPMEzfJY0LRFshWLdHEnjYkTS2qmLu0yzfmCVamMrfHVOQw98K7oa7dzb9WVU0oheS7Ab54r9htHstbhF9MkGgyovRtFFvVhZaQcUIOKSv"
    res = http.request(req)
    res
  end

  def nest2
    url = "https://developer-api.nest.com/"
    headers = {
      "Content-Type":  "application/json",
      "Authorization": "Bearer c.k4FCsfOcNz0DX1qssKhZ6GSCrKWECyrasXLDC0oPMEzfJY0LRFshWLdHEnjYkTS2qmLu0yzfmCVamMrfHVOQw98K7oa7dzb9WVU0oheS7Ab54r9htHstbhF9MkGgyovRtFFvVhZaQcUIOKSv"
    }
    res = HTTParty.get(url, :headers => headers, follow_redirects: true)
    res 
  end
end
