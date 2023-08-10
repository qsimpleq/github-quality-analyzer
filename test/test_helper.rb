# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
if ENV['RAILS_ENV'] == 'test' && ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start 'rails'
end

require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'

OmniAuth.config.test_mode = true

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

    def sign_in(user, _options = {})
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

      get callback_auth_url('github')
    end
  end
end
