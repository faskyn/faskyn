class Message < ActiveRecord::Base
  attachment :message_attachment, extension: ["pdf", "doc", "png", "jpg", "img", "xls"]

  belongs_to :conversation
  belongs_to :user

  #validates_presence_of :body, :conversation_id, :user_id
end
