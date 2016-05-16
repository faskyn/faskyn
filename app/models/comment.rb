class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user
  has_one :user_profile, through: :user, source: :profile
  has_many :comment_replies, dependent: :destroy
  has_many :users, through: :comment_replies, source: :user

  validates :commentable, presence: true
  validates :user, presence: true
  validates :body, presence: true, length: { maximum: 500 }

  scope :ordered, -> { order(updated_at: :desc) }

  def send_comment_creation_notification(commentable)
    commenters = ([commentable.user] + commentable.users).uniq - [ user ]
    commenters.each do | commenter |
      Notification.create(recipient_id: commenter.id, sender_id: user_id, notifiable: commentable, action: "commented")
    end
  end
end
