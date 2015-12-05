# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'faker'
include Faker

User.create!(
             email: "example@faskyn.org",
             password:              "foobar",
             password_confirmation: "foobar")

49.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@faskyn.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

users = User.order(:created_at).take(49)
positions = ["coder", "marketer", "salesman", "CEO", "designer", "product manager", "operations"]
users.each { |user| user.profile.create!(first_name: Faker::Name.first_name, 
                                         last_name: Faker::Name.last_name, 
                                         position: positions[rand(positions.length)] 
                                         company: Faker::Company.name) }

30.times do
  random1 = rand(1..2)
  random2 = random1 == 1 ? 2 : 1
  user = User.find(random1)
  user.tasks.create!(assigner_id: random1,
                     executor_id: random2, 
                     content: Faker::Lorem.sentence(2), 
                     deadline: Faker::Time.between(DateTime.now + 1, DateTime.now + 10) )
end