# frozen_string_literal: true

require 'open3'

class LintRepositoryService
  attr_reader :linter, :repository, :json_result, :parse_result, :result, :offense_count

  def initialize(repository)
    @repository = repository
    @linter = "Lint#{repository.language.capitalize}Service".constantize.new(repository)
  end

  def lint
    @linter.lint
    @result = @linter.result
    return if @linter.result[:error]

    @json_result = @linter.json_result
    self
  end

  def parse
    return if @result[:error]

    @parse_result = @linter.parse
    @offense_count = @linter.offense_count
    @parse_result
  end
end
