source 'https://rubygems.org'
ruby '2.2.3'

#default rails gems
gem 'rails', '4.2.4'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jquery-turbolinks', '~> 2.1'
gem 'turbolinks'
gem 'jquery-ui-rails', '~> 5.0.5'
gem 'jbuilder', '~> 2.0'
#basic app configuration gems
gem 'pg', '~> 0.18.3'
gem 'rack-rewrite', '~> 1.5', '>= 1.5.1'
gem 'rack-mini-profiler', '~> 0.9.8'
gem 'puma', '~> 2.13.4'
#gem for real-time(notifications for now, chat implemented with private pub)
gem 'pusher', '~> 0.15.1'
gem 'pusher-client', '~> 0.6.2'
#memcache with heroku and puma
gem 'dalli', '~> 2.7', '>= 2.7.5'
gem 'connection_pool', '~> 2.2'
#frontendgems
gem 'bootstrap-sass', '~> 3.3.5.1'
gem 'will_paginate', '~> 3.0.7'
gem 'bootstrap-will_paginate', '~> 0.0.10'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17', '>= 4.17.37'
gem 'bootstrap-social-rails', '~> 4.8'
gem 'simple_form', '~> 3.1.1'
gem 'font-awesome-rails', '~> 4.4'
gem 'fullcalendar-rails', '~> 2.5'
gem 'cocoon', '~> 1.2', '>= 1.2.7'
gem 'best_in_place', '~> 3.1'
#making fonts work with CDN
gem 'font_assets', '~> 0.1.12'
#populating fake data
gem 'faker', '~> 1.6', '>= 1.6.1'
#storing ENV credentials
gem 'figaro', '~> 1.1.1'
#qucik authentication and authorization
gem 'devise', '~> 3.5.2'
gem 'pundit', '~> 1.1'
#image and file uploading+AWS S3 storage
gem 'carrierwave', '~> 0.10.0'
gem 'fog', '~> 1.34.0'
gem 'mini_magick', '~> 4.3.3'
#refile for file uploading
gem 'refile', '~> 0.6.1', require: "refile/rails"
gem 'refile-mini_magick', '~> 0.2.0'
gem 'refile-s3', '~> 0.2.0'
gem 'remotipart', '~> 1.2', '>= 1.2.1'
#sidekiq for bg jobs and sinatra for sidekiq dashboard
gem 'sidekiq', '~> 4.1'
gem 'sinatra', '~> 1.4.6', :require => nil
#redis
gem 'redis', '~> 3.2.1'
#newrelic preformance checking
gem 'newrelic_rpm'
#searching gem + SQL query simplifier gem
gem 'ransack', '~> 1.7.0'
gem 'arel', '~> 6.0', '>= 6.0.3'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
#running servers easily
gem 'foreman', '~> 0.78.0'
gem 'net-ssh', '~> 3.0', '>= 3.0.1'
#finding links
gem 'rinku', '~> 1.7', '>= 1.7.3'
#social media and calendar integration
gem 'omniauth-twitter', '~> 1.2', '>= 1.2.1'
gem 'omniauth-linkedin', '~> 0.2.0'
gem 'google-api-client', '~> 0.8.6', require: 'google/api_client'
gem 'omniauth-google-oauth2', '~> 0.2.10'
#framework for handling timeformats in js
gem 'momentjs-rails', '~> 2.10', '>= 2.10.6'
gem 'local_time', '~> 1.0', '>= 1.0.3'


# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development do
  gem 'better_errors', '~> 2.1.1'
  gem 'quiet_assets', '~> 1.1.0'
  gem 'letter_opener', '~> 1.4.1'
  gem 'launchy', '~> 2.4.3'
  #database query optimazation
  gem 'bullet', '~> 4.14', '>= 4.14.10'
  gem 'hirb', '~> 0.7.3'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  #testing frameworks
  #gem 'rspec', '~> 3.4'
  #gem 'factory_girl', '~> 4.5'
  #gem 'capybara', '~> 2.6', '>= 2.6.2'
  #gem 'jasmine', '~> 2.4'
end

group :production do
  gem 'rails_12factor', '~> 0.0.3'
  gem 'rack-timeout', '~> 0.3.2'
  gem 'puma_worker_killer', '~> 0.0.5'
end

