class Conversation < ActiveRecord::Base

  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"

  has_many :messages, dependent: :destroy

  validates :sender, presence: true
  validates :recipient, presence: true

  validates_uniqueness_of :sender_id, scope: "recipient_id"

  scope :involving, -> (user) do 
    where("conversations.sender_id = ? OR conversations.recipient_id = ?", user.id, user.id)
  end

  scope :between, -> (sender_id, recipient_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id = ?) OR (conversations.sender_id = ? AND conversations.recipient_id = ?)", sender_id, recipient_id, recipient_id, sender_id)
  end

  def self.create_or_find_conversation(task_assigner_id, task_executor_id)
    Conversation.between(task_assigner_id, task_executor_id).first_or_create do |conversation|
      conversation.sender_id = task_assigner_id
      conversation.recipient_id = task_executor_id
    end
  end
end
