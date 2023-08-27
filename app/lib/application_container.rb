# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  register :USER_REPOSITORIES_EXPIRE, -> { ENV.fetch('USER_REPOSITORIES_EXPIRE', 10.minutes) }

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
    register :repository_check_job, -> { Stubs::RepositoryCheckJobStub }
  else
    register :octokit, -> { Octokit::Client }
    register :repository_check_job, -> { RepositoryCheckJob }
  end
end
