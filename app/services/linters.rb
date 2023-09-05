# frozen_string_literal: true

require 'open3'

class Linters
  attr_reader :linter, :repository, :json_result, :parse_result, :result, :offense_count

  def initialize(repository)
    @repository = repository
    @linter = "Linters::#{repository.language.capitalize}".constantize.new(repository)
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
