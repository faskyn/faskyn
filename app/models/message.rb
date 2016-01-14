class Message < ActiveRecord::Base
  serialize :link
  attachment :message_attachment, extension: ["pdf", "doc", "docx", "xls", "xlsx", "html", "png", "img", "jpg"]

  belongs_to :conversation
  belongs_to :user

  #validates_presence_of :body, :conversation_id, :user_id

  scope :with_file, -> { where.not(message_attachment_filename: nil) }
  scope :with_link, -> { where.not(link: :nil) }

  def link_array_to_string
    self.link
  end
end
