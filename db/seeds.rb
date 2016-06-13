# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'faker'
include Faker

if Rails.env.production?
  Industry.create!([{name: "IoT"}, {name: "AI"}, {name: "FinTech"}, {name: "Automotive"}, {name: "Health & Welness"}, {name: "IT & Data Science"}, {name: "FinTech"}, {name: "Education"}, {name: "Retail"}])

else
  User.create!(
               email: "example@superfaskynka.org",
               password:              "foobar1111",
               password_confirmation: "foobar1111")

  49.times do |n|
    email = "example-#{n+1}@superfaskynka.org"
    password = "password1111"
    User.create!(email: email,
                 password:              password,
                 password_confirmation: password)
  end

  users = User.order(created_at: :DESC).take(49)
  positions = ["coder", "marketer", "salesman", "CEO", "designer", "product manager", "operations"]
  users.each do |user| 
    user.build_profile(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, job_title: positions[rand(positions.length)], company: Faker::Company.name, description: Faker::Lorem.sentence(2))
    user.profile.save!
  end

  30.times do
    random1 = rand(1..2)
    random2 = random1 == 1 ? 2 : 1
    Task.create!(assigner_id: random1,
                       executor_id: random2, 
                       content: Faker::Lorem.sentence(2), 
                       deadline: Faker::Time.between(DateTime.now + 1, DateTime.now + 10) )
  end

  Industry.create!([{ name: "IoT" }, { name: "AI" }, { name: "Mobility & Transportation" }, { name: "Health & Wellness" }, { name: "IT & Data Science"},
                    { name: "FinTech" }, { name: "Education" }, { name: "Retail & Ecommerce" }, { name: "Industrial & Manufacturing" },
                    { name: "UAV" }, { name: "AR/VR" }, { name: "Consumer Internet" }, { name: "SaaS" }, { name: "Marketplace"},
                    { name: "Robotics" } ])

  product_users = User.order(created_at: :DESC).take(10)
  product_users.each do |user|
    5.times do
      user.products.build(industry_ids: [ Industry.all.order("RANDOM()").first.id, Industry.all.order("RANDOM()").first.id ] , oneliner: Faker::Lorem.sentence(8), name: Faker::Commerce.product_name, company: Faker::Company.name, website: Faker::Internet.url, description: Faker::Lorem.sentence(24),
        product_customers_attributes: [{customer: Faker::Company.name}, feature: Faker::Lorem.sentence}]
      user.product.save!
    end
  end
end