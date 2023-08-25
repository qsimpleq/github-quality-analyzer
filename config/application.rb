# frozen_string_literal: true

require_relative 'boot'
require 'dotenv/load' if %w[development test].include? ENV['RAILS_ENV']
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
autoload :ApplicationContainer, './app/lib/application_container'

module RailsProject66
  class Application < Rails::Application
    DEFAULT_HOST_URL = ENV.fetch("DEFAULT_HOST_URL_#{Rails.env.upcase}", 'http://127.0.0.1:3000')

    # Initialize configuration defaults for originally generated Rails version.
    config.i18n.default_locale = :ru
    config.load_defaults 7.0
    config.use_instantiated_fixtures = false
    config.use_transactional_fixtures = true

    routes.default_url_options = { host: ENV.fetch('BASE_URL', nil) }

    # Configuration for the application, engines, and railties goes here.
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
