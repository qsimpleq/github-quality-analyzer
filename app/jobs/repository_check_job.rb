# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default

  attr_reader :repository, :check, :github_info, :params

  def perform(params)
    @params = params
    current_user(@params[:user])
    @repository = @params[:repository]
    @check = Repository::Check.create(repository: @repository)

    repo_info
      &.fetch
      &.lint or return false

    @check.finish!
  end

  def repo_info
    @github_info = octokit.repo(@params[:repository].github_id)
    if @github_info.nil?
      @check.failed!
      nil
    else
      self
    end
  end

  def fetch
    FileUtils.mkdir_p(@repository.user_directory)

    @check.fetch
    begin
      if Dir.exist?(@repository.directory)
        Dir.chdir(@repository.directory)
        git = Git.open(@repository.directory)
        git.pull
      else
        Dir.chdir(@repository.user_directory)
        Git.clone(@github_info[:clone_url], nil, depth: 1)
      end
      @check.is_fetched!
      self
    rescue Git::FailedError
      @check.failed!
      nil
    end
  end

  def lint
    @check.check!
    linter = Repository::Linter.new(@repository)
    linter.run
    @check.is_checked!
    self
  rescue Git::FailedError
    @check.failed!
    nil
  end
end
