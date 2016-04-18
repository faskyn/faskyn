class PostComment < ActiveRecord::Base
  belongs_to :post, touch: true
  belongs_to :user
  has_one :user_profile, through: :user, source: :profile
  has_many :post_comment_replies, dependent: :destroy
  has_many :users, through: :post_comment_replies

  validates :post, presence: true
  validates :user, presence: true
  validates :body, presence: true, length: { maximum: 500 }

  scope :ordered, -> { order(updated_at: :desc) }

  def send_post_comment_reply_creation_notification(reply)
    post_repliers = ([user] + [post.user] + users).uniq - [ reply.user ]
    post_repliers.each do |replier|
      Notification.create(recipient_id: replier.id, sender_id: reply.user_id, notifiable: self.post, action: "commented")
    end
  end
end
