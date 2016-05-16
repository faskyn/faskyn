class CommentReply < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment, touch: true
  has_one :user_profile, through: :user, source: :profile

  validates :comment, presence: true
  validates :user, presence: true
  validates :body, presence: true, length: { maximum: 500 }

  scope :ordered, -> { order(updated_at: :asc) }

  def send_comment_reply_creation_notification(comment)
    repliers = ([comment.user] + [comment.commentable.user] + comment.users).uniq - [ user ]
    repliers.each do |replier|
      Notification.create(recipient_id: replier.id, sender_id: user_id, notifiable: comment.commentable, action: "commented")
    end
  end
end
