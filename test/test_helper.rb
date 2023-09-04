# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
if ENV['RAILS_ENV'] == 'test' && ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start 'rails'
end

require_relative '../config/environment'
require 'active_job/test_helper'
require 'rails/test_help'
require 'fakeredis/minitest'
require 'webmock/minitest'

ActiveJob::Base.queue_adapter = :test
OmniAuth.config.test_mode = true
I18n.locale = :ru

def t(key, **)
  if respond_to?(:controller)
    controller.t(key, **)
  else
    I18n.t(key, **)
  end
end

def fixture_json_load(*, **opts)
  JSON.parse(fixture_file_read(*), opts)
end

def fixture_file_read(*)
  File.read(File.join(fixtures_path, *))
end

# ActiveRecord/Tasks/DatabaseTasks implementation
def fixtures_path
  @fixtures_path ||= if ENV['FIXTURES_PATH']
                       Rails.root.join(ENV['FIXTURES_PATH']).to_s
                     else
                       Rails.root.join('test/fixtures').to_s
                     end
end

def mock_omniauth(user, _options = {})
  auth_hash = {
    credentials: {
      token: '123'
    },
    info: {
      email: user.email,
      nickname: user.nickname
    },
    provider: 'github',
    uid: '12345'
  }

  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

module ActionDispatch
  class IntegrationTest
    include AuthManager
    include AnyClients

    def sign_in(user, options = {})
      mock_omniauth(user, options)
      get callback_auth_path('github')
    end
  end
end
