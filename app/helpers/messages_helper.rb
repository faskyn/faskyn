module MessagesHelper

  def self_or_other(message)
    message.user == current_user ? "self" : "other"
  end

  def message_interlocutor(message)
    message.user == message.conversation.sender ? message.conversation.sender : message.conversation.recipient
  end

  def time_display(time)
    if time > Time.zone.now - 24.hours
      local_time(time, "%I:%M %p")
    else
      local_time(time, "%d %b %I:%M %p")
    end
  end
end
