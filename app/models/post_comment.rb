class PostComment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  has_one :user_profile, through: :user, source: :profile
  has_many :post_comment_replies, dependent: :destroy
  has_many :users, through: :post_comment_replies

  validates :user, presence: true
  validates :body, presence: true, length: { maximum: 500 }

  scope :ordered, -> { order(updated_at: :desc) }
  scope :included, -> { includes(:user, :user_profile) }

  def send_post_comment_reply_creation_notification(current_user)
    post_repliers = ([user] + [post.user] + users).uniq - [ current_user ]
    post_repliers.each do |replier|
      Notification.create(recipient_id: replier.id, sender_id: current_user.id, notifiable: self.post, action: "commented")
    end
  end
end
