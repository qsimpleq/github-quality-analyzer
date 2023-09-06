# frozen_string_literal: true

class LintRepositoryService
  attr_reader :linter, :repository, :json_result, :parsed_result, :result, :offense_count

  def initialize(repository)
    @repository = repository
    @linter = "Lint#{repository.language.capitalize}Service".constantize.new(repository)
  end

  def perform
    linted = @linter.perform
    @json_result = @linter.json_result
    @offense_count = @linter.offense_count
    @parsed_result = @linter.parsed_result
    @result = @linter.result
    linted
  end
end
