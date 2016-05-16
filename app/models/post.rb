class Post < ActiveRecord::Base
  mount_uploader :post_image, PostImageUploader

  belongs_to :user
  has_one :user_profile, through: :user, source: :profile
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :users, through: :comments, source: :user

  validates :user, presence: true

  validates :body, presence: { message: "can't be blank" }, length: { maximum: 500, message: "can't be longer than 500 characters" }

  # def send_comment_creation_notification(comment)
  #   post_commenters = ([user] + users).uniq - [ comment.user ]
  #   post_commenters.each do | commenter |
  #     Notification.create(recipient_id: commenter.id, sender_id: comment.user_id, notifiable: self, action: "commented")
  #   end
  # end

  # def send_post_creation_email_notification(writer)
  #   users = User.all - [writer]
  #   users.each do |reader|
  #     if reader.profile.present?
  #       PostCreatorJob.perform_later(self, writer, reader)
  #     end
  #   end
  # end
end
