class Message < ActiveRecord::Base
  serialize :link
  attachment :message_attachment, extension: ["pdf", "doc", "docx", "xls", "xlsx", "html", "png", "img", "jpg"]

  belongs_to :conversation
  belongs_to :user

  validates :conversation, presence: true
  validates :user, presence: true

  scope :with_file, -> { where.not(message_attachment_filename: nil) }
  scope :with_link, -> { where.not(link: :nil) }
end
