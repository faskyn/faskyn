class Profile < ActiveRecord::Base
  belongs_to :user, touch: true
  has_many :socials, dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  validates :user, presence: true
  validates_uniqueness_of :user_id

  validates :first_name, presence: { message: "can't be blank" }, length: { maximum: 50 }
  validates :last_name, presence: { message: "can't be blank" }, length: { maximum: 50 }
  validates :company, presence: { message: "can't be blank" }, length: { maximum: 50 }
  validates :job_title, presence: { message: "can't be blank" }, length: { maximum: 50 }

  def full_name
    [first_name.camelize, last_name.camelize].join(' ')
  end
end