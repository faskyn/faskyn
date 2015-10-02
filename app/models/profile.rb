class Profile < ActiveRecord::Base
  belongs_to :user

  mount_uploader :avatar, AvatarUploader

  validates :first_name, :presence => { :message => "can not be blank" },
                   length: { maximum: 50 }
  validates :last_name, :presence => { :message => "can not be blank" },
                   length: { maximum: 50 }
  validates :company, :presence => { :message => "can not be blank" },
                   length: { maximum: 50 }
  validates :job_title, presence: true,
                   length: { maximum: 50 }

end