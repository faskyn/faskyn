json.id notification.id
json.recipient_id notification.recipient_id
json.recipient_name notification.recipient.profile.full_name
json.sender_id notification.sender_id
json.sender_name notification.sender.profile.full_name
json.action notification.action
json.notifiable notification.notifiable_type
if notification.sender.avatar.url == "default.png"
  if Rails.env.development?
    json.profile_image_url "assets/small_thumb_default.png"
  elsif Rails.env.production?
    json.profile_image_url "//s3.amazonaws.com/faskyn2/static/small_thumb_default.png"
  end
else
  json.profile_image_url notification.sender.profile.avatar.url(:small_thumb)
end
json.what do
  json.did "#{notification.action} on a #{ human_model_name(notification.notifiable_type) }"
end
json.url checking_decreasing_user_notifications_path(current_user, notification: notification)