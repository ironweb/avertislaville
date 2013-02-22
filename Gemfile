source 'https://rubygems.org'

gem 'rails', '3.2.12'
gem 'rails-i18n'

gem 'pg'
gem 'activerecord-postgis-adapter'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2'
  gem 'compass-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# Use devise for Auth
gem "devise"

# Kaminari for paging
gem "kaminari"

# DRY ressources (used for admin)
gem 'inherited_resources'

# Sorted for sorting
gem 'sorted'

# Deploy with Capistrano
gem 'capistrano'
gem 'capistrano-ext'
gem 'rvm-capistrano'

gem 'simple_form'

gem 'rest-client'

gem 'active_attr'
gem 'compass'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

platform :ruby do
  group :production do
    # Use unicorn as the app server
    #gem 'unicorn'
  end
  group :development do
    gem 'better_errors'
    gem 'binding_of_caller'
  end

  group :development, :test do
    gem 'debugger'
  end

  group :test do
    gem 'launchy'
    gem 'guard-spork'
    gem 'guard-rspec'
    gem 'spork'
    gem 'rb-fsevent'
    gem 'capybara'
    gem 'factory_girl_rails'
    gem 'simplecov', :require => false
    # Use database_cleaner if you'd like to run full webkit specs
    # gem 'database_cleaner'
    # gem 'capybara-webkit', '0.7.2'
  end
end

group :development do
  gem 'sextant'
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'awesome_print'
end

group :production do
  gem 'unicorn'
end

platforms :mswin, :mingw do
  gem 'spork'
  gem 'factory_girl_rails'
end
