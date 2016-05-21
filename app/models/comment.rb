class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_one :user_profile, through: :user, source: :profile
  has_many :comment_replies, dependent: :destroy
  has_many :users, through: :comment_replies, source: :user

  validates :commentable, presence: true
  validates :user, presence: true
  validates :body, presence: true, length: { maximum: 500 }

  scope :ordered, -> { order(updated_at: :desc) }
  scope :with_profile, -> { includes(:user, :user_profile) }

  def self.ordered_with_profile
    ordered.with_profile
  end

  def send_comment_creation_notification(commentable)
    if commentable_type == "Post"
      commentable_user = commentable.user
    else
      commentable_user = commentable.owner
    end
    commented = ([commentable_user] + commentable.commenters).uniq - [ user ]
    commented.each do | commenter |
      Notification.create(recipient_id: commenter.id, sender_id: user_id, notifiable: commentable, action: "commented")
    end
  end
end
