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
    unless lint
      CheckMailer.with(check: @check, error: @linter.result[:error]).lint_failed.deliver_later
      return failed
    end
    @check.is_linted!

    @check.parse!
    parse or return failed
    @check.is_parsed!

    @check.finish!
    CheckMailer.with(check: @check).lint_with_offenses.deliver_later if @check.offense_count.positive?
  ensure
    FileUtils.rmtree(@repository.directory)
  end

  def repo_info
    @github_info = octokit.repo(@params[:repository].github_id)
    return if @github_info.nil?

    self
  end

  def fetch
    FileUtils.mkdir_p(@repository.user_directory)
    Dir.chdir(@repository.user_directory)

    begin
      git = Git.clone(@github_info[:clone_url], nil, depth: 1)
      @check.commit_id = git.log.first.sha[0, 7]

      self
    rescue Git::FailedError
      nil
    end
  ensure
    Dir.chdir(Rails.root)
  end

  def lint
    @linter = Repository::Linter.new(@repository)
    return unless @linter.lint

    self
  end

  def parse
    result = @linter.parse or return
    @check.offense_count = @linter.offense_count
    @check.check_result = JSON.generate(result)
    @check.check_passed = true if @check.offense_count.zero?
    self
  end

  def failed
    @check.failed!
    false
  end
end
