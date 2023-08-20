# frozen_string_literal: true

require 'open3'

class Repository
  class Linter
    attr_reader :linter, :repository, :json_result, :parse_result, :result, :offense_count

    def initialize(repository)
      @repository = repository
      @linter = "Repository::Linter::#{repository.language.capitalize}".constantize.new(repository)
    end

    def run
      @linter.run
      @json_result = @linter.json_result
      @result = @linter.result
      self
    end

    def parse
      @parse_result = @linter.parse
      @offense_count = @linter.offense_count
      @parse_result
    end
  end
end
