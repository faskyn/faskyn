class Social < ActiveRecord::Base
  belongs_to :profile

  def self.find_or_create_from_auth_hash(auth_hash)
    #:provider, :uid, :token, :secret, :first_name, :last_name, :page_url, :picture_url, :location, :description, :phone
    social_acc = where(provider: auth_hash.provider).first_or_create
    social_acc.update(
      #no first_name, last_name and phone for twitter
      uid: auth_hash.uid,
      token: auth_hash.credentials.token,
      secret: auth_hash.credentials.secret,
      picture_url: auth_hash.info.image,
      location: auth_hash.info.location,
      description: auth_hash.info.description,
      first_name: auth_hash.info.first_name || nil,
      last_name: auth_hash.info.last_name || nil,
      phone: auth_hash.info.phone || nil,
      page_url:   case social_acc.provider
                  when 'twitter' then auth_hash.info.urls.Twitter
                  when 'linkedin' then auth_hash.info.urls.public_profile
                  when 'angellist' then auth_hash.info.urls.Angellist
                  end
      # page_url = auth_hash.info.urls.Twitter
      # page_url = auth_hash.info.urls.public_profile
      # page_url = auth_hash.info.urls.Angellist
      )
    social_acc
  end
end
