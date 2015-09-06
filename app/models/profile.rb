class Profile < ActiveRecord::Base
  validates :first_name, presence: true,
                   length: { maximum: 50 }
  validates :last_name, presence: true,
                   length: { maximum: 50 }
  validates :company, presence: true,
                   length: { maximum: 50 }
  validates :job_title, presence: true,
                   length: { maximum: 50 }

  belongs_to :user
end