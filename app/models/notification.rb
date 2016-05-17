class Notification < ActiveRecord::Base
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"
  belongs_to :notifiable, polymorphic: true

  has_one :sender_profile, through: :sender, source: :profile
  has_one :recipient_profile, through: :recipient, source: :profile

  after_create :increasing_notification

  validates :sender, presence: true
  validates :recipient, presence: true

  validates :notifiable_type, presence: true
  validates :notifiable_id, presence: true
  validates :action, presence: true

  scope :not_chat, -> { where.not(notifiable_type: "Message") }
  scope :chat, -> { where(notifiable_type: "Message") }
  scope :task, -> { where(notifiable_type: "Task") }
  scope :post, -> { where(notifiable_type: "Post") }
  scope :unchecked, -> { where(checked_at: nil) }
  scope :checked, -> { where.not(checked_at: nil) }

  scope :this_notifiable_comments, -> (notifiable_type, notifiable_id) do
    where("notifications.notifiable_type = ? AND notifications.notifiable_id = ?", notifiable_type, notifiable_id)
  end

  scope :between_chat_recipient, -> (sender_id) do
    where("notifications.sender_id = ? AND notifications.notifiable_type = ?", sender_id, "Message")
  end

  scope :between_other_recipient, -> (sender_id) do
    where("notifications.sender_id = ? AND notifications.notifiable_type != ?", sender_id, "Message")
  end

  def self.pagination_per_page
    12
  end

  def checked?
    checked_at
  end
  
  def check_notification #chat notification gets checked
    update_attribute(:checked_at, Time.zone.now) if checked_at.nil?
  end

  def increasing_notification
    if notifiable_type == "Message"
      recipient.increase_new_chat_notifications
      increased_chat_number_pusher
    else
      recipient.increase_new_other_notifications
      increased_other_number_pusher
    end      
  end

  def increased_chat_number_pusher(number = recipient.new_chat_notification)
    Pusher.trigger_async('private-'+ recipient_id.to_s, 'new_chat_notification', { number: number })
  end

  def increased_other_number_pusher(number = recipient.new_other_notification)
    Pusher.trigger_async('private-'+ recipient_id.to_s, 'new_other_notification', { number: number })  
  end
end
