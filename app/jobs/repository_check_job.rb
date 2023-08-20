# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default

  attr_reader :repository, :check, :linter, :github_info, :params

  def perform(params)
    @params = params
    current_user(@params[:user])
    @repository = @params[:repository]
    @check = Repository::Check.create(repository: @repository)

    @check.fetch!
    repo_info&.fetch or return failed
    @check.is_fetched!

    @check.lint!
    lint or return failed
    @check.is_linted!

    @check.parse!
    parse or return failed
    @check.is_parsed!

    @check.finish!
  end

  def repo_info
    @github_info = octokit.repo(@params[:repository].github_id)
    return if @github_info.nil?

    self
  end

  def fetch
    FileUtils.mkdir_p(@repository.user_directory)

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

      Dir.chdir(Rails.root)

      self
    rescue Git::FailedError
      nil
    end
  end

  def lint
    @linter = Repository::Linter.new(@repository)
    result = @linter.run.result
    return if result[:status] > 1

    self
  end

  def parse
    offenses = @linter.parse
    @check.offense_count = @linter.offense_count
    @check.check_result = JSON.generate(offenses)
    @check.check_passed = true if @check.offense_count.zero?
    self
  end

  def failed
    @check.failed!
    false
  end
end