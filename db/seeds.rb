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
  Industry.create!([{name: "IoT"}, {name: "AI"}, {name: "FinTech"}])

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

  #user.build_profile(first_name: "Peter", last_name: "Smith", job_title: "boss", company: "MU", description: "lorem epsum hullon")
  #user.profile.create!(first_name: "Peter", last_name: "Smith", job_title: "boss", company: "MU", description: "lorem epsum hullon")
  #user.build.profile(first_name: "Peter", last_name: "Smith", job_title: "boss", company: "MU", description: "lorem epsum hullon")

  30.times do
    random1 = rand(1..2)
    random2 = random1 == 1 ? 2 : 1
    Task.create!(assigner_id: random1,
                       executor_id: random2, 
                       content: Faker::Lorem.sentence(2), 
                       deadline: Faker::Time.between(DateTime.now + 1, DateTime.now + 10) )
  end

  Industry.create!([{name: "IoT"}, {name: "AI"}, {name: "FinTech"}])
end