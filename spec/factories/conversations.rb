# FactoryGirl.define do
#   factory :conversation do
#     association :sender, factory: :user
#     association :recipient, factory: :user
#   end

#   factory :message do
#     user
#     conversation

#     factory :message_with_body do
#       body { Faker::Lorem.paragraph }
#     end

#     factory :message_with_attachment do
#       message_attachment_id { Faker::Number.between(1, 10) }
#       message_attachment_filename "file.pdf"
#     end
#   end
# end