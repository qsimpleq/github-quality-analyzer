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
  register :repository_check_job, -> { RepositoryCheckJob }
  register :fetch_repositories_job, -> { FetchRepositoriesJob }
  register :fetch_repositories_service, -> { FetchRepositoriesService }

  if Rails.env.test?
    autoload :Stubs, Rails.root.join('app/lib/stubs')
    register :octokit, -> { Stubs::OctokitClientStub }
    register :repository_check_service, -> { Stubs::RepositoryCheckServiceStub }
    register :repository_update_service, -> { Stubs::RepositoryUpdateServiceStub }
  else
    register :octokit, -> { Octokit::Client }
    register :repository_check_service, -> { RepositoryCheckService }
    register :repository_update_service, -> { RepositoryUpdateService }
  end
end
