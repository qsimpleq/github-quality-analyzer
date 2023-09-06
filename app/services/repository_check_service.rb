# frozen_string_literal: true

class RepositoryCheckService
  include AnyClients

  attr_reader :repository, :check, :linter

  def perform(repository)
    current_user(repository.user)
    @repository = repository
    @check = Repository::Check.create(repository:)

    @check.run_check!
    github_info&.fetch or return failed

    unless lint
      CheckMailer.with(check: @check, error: @linter.result[:error]).check_failed.deliver_later
      return failed
    end

    parse or return failed
    @check.mark_as_finish!
    CheckMailer.with(check: @check).check_with_offenses.deliver_later if @check.offense_count.positive?
  ensure
    FileUtils.rmtree(@repository.directory)
  end

  def github_info
    @github_info = octokit(@repository.user).repo(repository.github_id)
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
    @linter = Linters.new(@repository)
    @linter.lint
    return unless @linter.lint

    self
  end

  def parse
    result = @linter.parse or return
    @check.offense_count = @linter.offense_count
    @check.check_result = JSON.generate(result)
    @check.passed = true if @check.offense_count.zero?
    self
  end

  def failed
    @check.mark_as_fail!
    false
  end
end
