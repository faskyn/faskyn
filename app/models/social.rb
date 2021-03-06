class Social < ActiveRecord::Base
  belongs_to :profile

  validates :profile, presence: true

  validates :uid, presence: true
  validates :token, presence: true
  validates :provider, presence: true

  def user
    profile.user
  end

  def self.find_or_create_from_auth_hash(auth_hash)
    social_acc = where(provider: auth_hash.provider).first_or_create
    social_acc.update(
      #no first_name, last_name and phone for twitter
      uid: auth_hash.uid,
      token: auth_hash.credentials.token,
      secret: auth_hash.credentials.secret,
      nickname: auth_hash.info.nickname,
      picture_url: auth_hash.info.image,
      location: auth_hash.info.location,
      description: auth_hash.info.description,
      first_name: auth_hash.info.first_name || nil,
      last_name: auth_hash.info.last_name || nil,
      phone: auth_hash.info.phone || nil,
      page_url:   case social_acc.provider
                  when 'twitter' then auth_hash.info.urls.Twitter
                  when 'linkedin' then auth_hash.info.urls.public_profile
                  end
      )
    social_acc
  end
end
