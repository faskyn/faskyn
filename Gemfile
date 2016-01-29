source 'https://rubygems.org'
ruby '2.2.3'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# turbolinks for jquery
gem 'jquery-turbolinks', '~> 2.1'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
#jquery-UI
gem 'jquery-ui-rails', '~> 5.0.5'
#database
gem 'pg', '~> 0.18.3'
gem 'rack-mini-profiler', '~> 0.9.8'
#fay+private_pub for chatting
gem 'private_pub', '~> 1.0.3'
#gem for real-time(notifications for now, chat implemented with private pub)
gem 'pusher', '~> 0.15.1'
gem 'pusher-client', '~> 0.6.2'
#webserver (heroku recommends puma as default)
gem 'puma', '~> 2.13.4'
#memcache with heroku and puma
gem 'dalli', '~> 2.7', '>= 2.7.5'
gem 'connection_pool', '~> 2.2'
#bootstrap and willpaginate
gem 'bootstrap-sass', '~> 3.3.5.1'
gem 'will_paginate', '~> 3.0.7'
gem 'bootstrap-will_paginate', '~> 0.0.10'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17', '>= 4.17.37'
#simple form
gem 'simple_form', '~> 3.1.1'
#font awesome
gem 'font-awesome-rails', '~> 4.4'
#making fonts work with CDN
gem 'font_assets', '~> 0.1.12'
#bootstrap buttons for social media
gem 'bootstrap-social-rails', '~> 4.8'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
#populating fake data
gem 'faker', '~> 1.6', '>= 1.6.1'
#storing ENV credentials
gem 'figaro', '~> 1.1.1'
#qucik authentication and invitation
gem 'devise', '~> 3.5.2'
gem 'devise_invitable', '~> 1.5.2'
#image and file uploading+AWS S3 storage
gem 'carrierwave', '~> 0.10.0'
gem 'fog', '~> 1.34.0'
gem 'mini_magick', '~> 4.3.3'
#refile for file uploading
gem 'refile', '~> 0.6.1', require: "refile/rails"
gem 'refile-mini_magick', '~> 0.2.0'
gem 'refile-s3', '~> 0.2.0'
gem 'remotipart', '~> 1.2', '>= 1.2.1'
#bg worker
gem 'sidekiq', '~> 4.1'
#sinatra for sidekiq dashboard
gem 'sinatra', '~> 1.4.6', :require => nil
#redis
gem 'redis', '~> 3.2.1'
#newrelic preformance checking
gem 'newrelic_rpm'
#setting timeout
gem 'rack-timeout', '~> 0.3.2'
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
#calendar gem
gem 'fullcalendar-rails', '~> 2.5'
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
  #letter opener for dev env
  gem 'letter_opener', '~> 1.4.1'
  gem 'launchy', '~> 2.4.3'
  #database query optimazation
  gem 'bullet', '~> 4.14', '>= 4.14.10'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :production do
  gem 'rails_12factor', '~> 0.0.3'
end

