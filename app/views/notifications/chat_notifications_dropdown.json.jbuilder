json.array! @chat_notifications do |notification|
  if lookup_context.template_exists?(notification.action, "notifications/actions", true)
    json.partial! "notifications/actions/#{notification.action}", notification: notification
  end
end