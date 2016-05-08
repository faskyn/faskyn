class Message < ActiveRecord::Base
  serialize :link
  attachment :message_attachment, store: 'message_files_backend', extension: ["pdf", "txt", "doc", "docx", "xls", "xlsx", "html", "png", "img", "jpg"]

  belongs_to :conversation
  belongs_to :user

  validates :conversation, presence: true
  validates :user, presence: true
  validates :body, length: { maximum: 5000, message: "can't be longer than 5000 characters" }

  scope :with_file, -> { where.not(message_attachment_filename: nil) }
  scope :with_link, -> { where.not(link: :nil) }
end
