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
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# turbolinks for jquery
gem 'jquery-turbolinks', '~> 2.1.0'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
#database
gem 'pg', '~> 0.18.3'
#fay+private_pub for chatting
gem 'private_pub', '~> 1.0.3'
#server
gem 'puma', '~> 2.13.4'
#bootstrap
gem 'bootstrap-sass', '~> 3.3.5.1'
#pagination
gem 'will_paginate', '~> 3.0.7'
#pagination w/ bootstrap
gem 'bootstrap-will_paginate', '~> 0.0.10'
#simple form
gem 'simple_form', '~> 3.1.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
#populating fake data
gem 'faker', '~> 1.5.0'
#storing ENV credentials
gem 'figaro', '~> 1.1.1'
#qucik authentication
gem 'devise', '~> 3.5.2'
#inviting users via email
gem 'devise_invitable', '~> 1.5.2'
#attaching pics
gem 'paperclip', '~> 4.3.0'
#storing production files on amazon
gem 'aws-sdk', '< 2.0'
#for email async
gem 'sidekiq', '~> 3.5.0'
#sinatra for sidekiq dashboard
gem 'sinatra', '~> 1.4.6', :require => nil
#part of sinatra; as of writing must be <2.0 because of bug
gem 'tilt', '>= 1.3.4', '~> 1.3'
#redis for sidekiq
gem 'redis', '~> 3.2.1'
#searching gem
gem 'ransack', '~> 1.7.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
#running servers easily
gem 'foreman', '~> 0.78.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development do
  gem 'better_errors', '~> 2.1.1'
  gem 'quiet_assets', '~> 1.1.0'
  #letter opener for dev env
  gem 'letter_opener', '~> 1.4.1'
  gem 'launchy', '~> 2.4.3'
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

