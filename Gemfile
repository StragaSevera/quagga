source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'

# Dotenv
gem 'dotenv-rails', :require => 'dotenv/rails-now'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SLIM instead of ERB
gem 'slim-rails'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Boot'em on, Strap!
gem 'bootstrap-sass'

# Use Font Awesome instead of Glyphicons
gem 'font-awesome-rails'

# Fix browser problems
gem 'selectivizr-rails'

# Divide anything to pages
gem 'will_paginate'
gem 'bootstrap-will_paginate'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt'

# Improve Russian language support
gem 'russian'
gem 'unicode_utils'

# Authorization
gem 'devise'
gem 'cancancan'

# JSON
gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'

# Attachment handling
gem 'carrierwave'
gem 'remotipart'
gem 'cocoon'

# PubSub
gem 'private_pub'
gem 'thin'

# Variables in JS
gem 'gon'

# Responders
gem 'responders', '~> 2.0'

# OmniAuth
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'doorkeeper'

# Async
gem 'sidekiq'
gem 'whenever'

# Full-text search
gem 'mysql2'
gem 'thinking-sphinx'

# Unicorn
gem 'unicorn'

# Caching
gem 'redis-rails'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Spring speeds up development by keeping your application running in the background. 
  # Read more: https://github.com/rails/spring
  gem 'spring-commands-rspec'

  # Debug by pry
  gem 'pry-byebug'
  gem 'pry-rails'

  # Testing by rspec
  gem 'rspec-rails'
  gem 'factory_girl_rails'

  # Open main in browser
  gem 'letter_opener'
end

group :test do
  # Launch test in automode
  gem 'guard'
  gem 'guard-rspec'
  
  gem 'shoulda-matchers', '~> 3.0'

  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'capybara-email'
  gem 'poltergeist'

  gem 'database_cleaner'
  gem 'launchy'

  gem 'json_spec'

  gem 'timecop'
end
