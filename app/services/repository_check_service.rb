# frozen_string_literal: true

class RepositoryCheckService
  include AnyClients

  attr_reader :repository, :linter, :error

  def initialize(repository)
    @repository = repository
    @check = Repository::Check.create(repository: @repository)
    @linter = LintRepositoryService.new(@repository)
  end

  def perform
    @check.run_check!
    unless github_info && fetch && check
      CheckMailer.with(check: @check, error: @error).check_failed.deliver_later
      @check.mark_as_fail!
      return false
    end

    @check.mark_as_finish!
    CheckMailer.with(check: @check).check_with_offenses.deliver_later if @check.offense_count.positive?

    true
  ensure
    FileUtils.rmtree(@repository.directory)
  end

  private

  def github_info
    @github_info ||= octokit(@repository.user).repo(repository.github_id)
    if @github_info.nil?
      @error = I18n.t('services.repository_check_service.github_info_error')
      return false
    end

    true
  end

  def fetch
    FileUtils.mkdir_p(@repository.user_directory)
    Dir.chdir(@repository.user_directory)

    begin
      git = Git.clone(@github_info[:clone_url], nil, depth: 1)
      @check.commit_id = git.log.first.sha[0, 7]
      true
    rescue Git::FailedError
      @error = I18n.t('services.repository_check_service.git_clone_error')
      false
    end
  ensure
    Dir.chdir(Rails.root)
  end

  def check
    unless @linter.perform
      @error = @linter.result[:error]
      return false
    end

    @check.offense_count = @linter.offense_count
    @check.check_result = JSON.generate(@linter.parsed_result)
    @check.passed = true if @check.offense_count.zero?

    true
  end
end
