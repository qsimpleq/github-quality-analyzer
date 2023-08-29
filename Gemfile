# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'
gem 'dotenv-rails', groups: %i[development test]

gem 'puma', '~> 5.0' # Use the Puma web server [https://github.com/puma/puma]
gem 'rails', '~> 7.0.6' # Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"

gem 'cssbundling-rails' # Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem 'jbuilder' # Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jsbundling-rails' # Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem 'sprockets-rails' # The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'stimulus-rails' # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'turbo-rails' # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]

# gem "bcrypt", "~> 3.1.7" # Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "kredis" # Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "sassc-rails" # Use Sass to process CSS
gem 'aasm'
gem 'active_storage_validations'
gem 'ancestry' # Ancestry allows rails ActiveRecord models to be organized as a tree structure (or hierarchy).
gem 'bootsnap', require: false # Reduces boot times through caching; required in config/boot.rb
gem 'bootstrap'
gem 'cocoon'
gem 'connection_pool'
gem 'dry-container'
gem 'enumerize' # Enumerated attributes with I18n and ActiveRecord/Mongoid/MongoMapper/Sequel support
gem 'faker'
gem 'faraday-retry'
gem 'git'
gem 'image_processing', '~> 1.2' # Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'kaminari' # A pagination engine plugin for Rails 4+ and other modern frameworks
gem 'octokit' # Ruby toolkit for the GitHub API
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'
gem 'pundit'
gem 'ransack' # Object-based searching for Active Record
gem 'rubocop', require: false
gem 'rubocop-capybara', require: false
gem 'rubocop-minitest', require: false
gem 'rubocop-performance', require: false
gem 'rubocop-rails', require: false
gem 'rubocop-rake', require: false
gem 'rubocop-slim', require: false
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'simple_form'
gem 'slim-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem

group :production do
  gem 'pg'
  gem 'redis', '~> 4.0' # Use Redis adapter to run Action Cable in production
end

group :development, :test do
  gem 'annotate' # Adds model attributes/routes to top of model files/routes file
  gem 'debug', platforms: %i[mri mingw x64_mingw] # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'fakeredis'
  gem 'html2slim', github: 'slim-template/html2slim'
  gem 'i18n-tasks', require: false
  gem 'slim_lint', require: false
  gem 'sqlite3', '~> 1.4' # Use sqlite3 as the database for Active Record
end

group :development do
  # gem "rack-mini-profiler" # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "spring" # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem 'web-console' # Use console on exceptions pages [https://github.com/rails/web-console]
end

group :test do
  gem 'capybara' # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'minitest-power_assert'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'webdrivers'
  gem 'webmock'
end
