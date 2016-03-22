class Post < ActiveRecord::Base
  belongs_to :user
  has_one :user_profile, through: :user, source: :profile
  has_many :post_comments, dependent: :destroy
  has_many :users, through: :post_comments #for post_comment notifications
  #has_many :post_replies, through: :post_comments, dependent: :destroy

  validates :user, presence: true

  validates :body, presence: { message: "can not be blank" }, length: { maximum: 500, message: "can't be longer than 500 characters" }

  def pagination_per_page
    12
  end

  def send_post_comment_creation_notification(current_user)
    post_commenters = ([user] + users).uniq - [ current_user ]
    post_commenters.each do | commenter |
      Notification.create(recipient_id: commenter.id, sender_id: current_user.id, notifiable: self, action: "commented")
    end
  end

  # def send_post_creation_email_notification(writer)
  #   users = User.all - [writer]
  #   users.each do |reader|
  #     if reader.profile.present?
  #       PostCreatorJob.perform_later(self, writer, reader)
  #     end
  #   end
  # end
end
