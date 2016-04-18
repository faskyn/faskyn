# FactoryGirl.define do
#   factory :notification do
#     notifiable_id { Faker::Number.between(1, 10) }
#     notifiable_type { Faker::Lorem.word }
#     action { Faker::Hipster.word }
#     checked_at { Faker::Time.between(DateTime.now - 2, DateTime.now - 3)  }
#     association :sender, factory: :user
#     association :recipient, factory: :user
#   end
# end
