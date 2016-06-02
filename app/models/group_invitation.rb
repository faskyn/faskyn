class GroupInvitation < ActiveRecord::Base
  attr_accessor :email
  belongs_to :recipient, class_name: "User"
  belongs_to :sender, class_name: "User"
  belongs_to :group_invitable, polymorphic: true

  validates :recipient, presence: true
  validates :sender, presence: true
  validates :group_invitable_id, presence: true
  validates :group_invitable_type, presence: true
  validates :email, presence: { message: "can't be blank" }

  scope :pending_user, -> (user) { where("recipient_id = ? AND accepted = ?", user.id, false) }
end