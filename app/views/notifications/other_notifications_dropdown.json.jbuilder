json.array! @other_notifications do |notification|
  json.id notification.id
  json.recipient_id notification.recipient_id
	json.recipient_name notification.recipient.profile.full_name
	json.sender_id notification.sender_id
  json.sender_name notification.sender.profile.full_name
	json.action notification.action
  json.notifiable notification.notifiable_type
  json.profile_image_url notification.sender.profile.avatar_url
  if notification.notifiable_type == "Task"
    json.what do
       json.did "#{notification.action} you a #{notification.notifiable_type.underscore}"
    end
    json.url user_path(notification.sender ,check_and_decrease: true, task_notification_id: notification.notifiable_id)
  elsif notification.notifiable_type == "Post"
    json.what do
      json.did "#{notification.action} on a #{notification.notifiable_type.underscore}"
    end
    json.url posts_path(anchor: "post_#{notification.notifiable_id}", check_and_decrease: true, post_id: notification.notifiable_id)
  end
end