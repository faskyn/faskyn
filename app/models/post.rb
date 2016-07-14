class Post < ActiveRecord::Base
  mount_uploader :post_image, PostImageUploader
  include Concerns::Commentable
  include Concerns::Notifiable

  belongs_to :user
  has_one :user_profile, through: :user, source: :profile

  validates :user, presence: true
  validates :body, presence: { message: "can't be blank" }, length: { maximum: 500, message: "can't be longer than %{count} characters" }

  validate :post_daily_limit, on: :create

  scope :last_day, -> { where("created_at > ?", Time.zone.now - 24.hours) }


  private

    def post_daily_limit
      if user.posts.last_day.any?
        errors.add :base, "You can only create one post a day."
      end
    end
end
