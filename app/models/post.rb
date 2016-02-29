class Post < ActiveRecord::Base
  belongs_to :user
  has_one :user_profile, through: :user, source: :profile
  has_many :post_comments, dependent: :destroy
  #has_many :post_replies, through: :post_comments, dependent: :destroy

  validates :body, presence: { message: "can not be blank" }, length: { maximum: 140, message: "can't be longer than 140 characters" }

  def pagination_per_page
    12
  end
end
