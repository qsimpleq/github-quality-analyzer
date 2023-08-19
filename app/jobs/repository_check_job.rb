# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default

  attr_reader :repository, :check, :github_info, :params

  def perform(params)
    @params = params
    current_user(@params[:user])
    @repository = @params[:repository]
    @check = Repository::Check.create(repository: @repository)

    unless repo_info&.fetch&.lint
      @check.failed!
      return false
    end

    @check.finish!
  end

  def repo_info
    @github_info = octokit.repo(@params[:repository].github_id)
    return if @github_info.nil?

    self
  end

  def fetch
    FileUtils.mkdir_p(@repository.user_directory)

    @check.fetch!
    begin
      if Dir.exist?(@repository.directory)
        Dir.chdir(@repository.directory)
        Git.open(@repository.directory).pull
      else
        Dir.chdir(@repository.user_directory)
        Git.clone(@github_info[:clone_url], nil, depth: 1)
      end
      git = Git.open(@repository.directory)
      @check.commit_id = git.log.first.sha[0, 8]
      @check.is_fetched
      @check.save
      self
    rescue Git::FailedError
      nil
    end
  end

  def lint
    @check.check!
    linter = Repository::Linter.new(@repository)
    result = linter.run.result
    offenses = linter.parse
    @check.is_checked!

    @check.offense_count = result[:result][:summary][:offense_count]
    @check.check_result = JSON.generate(offenses)
    @check.check_passed = true if result[:status] == 0 && @check.offense_count.zero?
    @check.save
    self
  end
end
