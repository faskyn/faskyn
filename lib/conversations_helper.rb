module ConversationsHelper
  def broadcast_to_conversation(message_receiver_id, &block)
    message = capture(&block)
    Pusher["private-" + "conversation_#{message_receiver_id}"].trigger('message-sent', { message: message })
  end
end