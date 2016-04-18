# FactoryGirl.define do
#   factory :user do
#     #email { Faker::Internet.email }
#     sequence(:email) { |n| "example#{n}@gmail.com" }
#     #sequence(:email) { Faker::Internet.email }

#     password 'example0000'
#     password_confirmation 'example0000'
#     new_chat_notification { Faker::Number.between(0, 10) }
#     new_other_notification { Faker::Number.between(0, 10) } 
#   end

#   # factory :second_user do
#   #   email { Faker::Internet.email }
#   #   password 'example0000'
#   #   password_confirmation 'example0000'
#   #   new_chat_notification { Faker::Number.between(0, 10) }
#   #   new_other_notification { Faker::Number.between(0, 10) }
#   # end
# end