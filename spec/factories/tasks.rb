# FactoryGirl.define do
#   factory :task do
#     content { Faker::Lorem.sentence }
#     deadline { Faker::Time.between(DateTime.now + 2, DateTime.now + 3) }
#     association :executor, factory: :user
#     association :assigner, factory: :user
#   end
# end