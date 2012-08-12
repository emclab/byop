source 'http://rubygems.org'

gem 'rails', '3.2.3'
gem 'sqlite3'  
gem 'database_cleaner'
gem 'jquery-rails', '~>1.0.19'
gem 'simple_form'
gem 'will_paginate'  #, '~> 3.0'
#gem 'rufus-scheduler'

# Gemfile
#group :production do
#  gem 'mysql2', '>=0.2.6'
#end

#   Gems used only for assets and not required
# in production environments by default.
group :assets do
  group :production do
    gem 'execjs'
    gem 'therubyracer', :platforms => :ruby
  end
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
# Pretty printed test output  
  gem "rspec-rails", ">= 2.0.0"
  #gem "cucumber-rails", ">=0.3.2"
  gem 'webrat', ">= 0.7.2"
  gem 'factory_girl_rails' #, '~> 3.0'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', '0.8.2', :require => false
end
