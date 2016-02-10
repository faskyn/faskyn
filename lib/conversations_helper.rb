module ConversationsHelper
  def broadcast_to_conversation(conversation_id, message_receiver_id, &block)
    message = capture(&block)
    Pusher["private-" + "conversation_#{message_receiver_id}"].trigger('message-sent', { message: message })
  end
end