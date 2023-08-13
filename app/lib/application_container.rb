# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  register :redis do
    @register_redis ||= ConnectionPool::Wrapper.new do
      if Rails.env.production?
        Redis.new(url: ENV.fetch('REDIS_URL'))
      else
        Redis.new
      end
    end
  end

  if Rails.env.test?
    autoload :Stubs, Rails.root.join('app/lib/stubs')
    register :octokit, -> { Stubs::OctokitClientStub }
  else
    register :octokit, -> { Octokit::Client }
  end
end
