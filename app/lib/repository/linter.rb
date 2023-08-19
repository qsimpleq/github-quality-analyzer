# frozen_string_literal: true

require 'open3'

class Repository
  class Linter
    attr_reader :linter, :repository, :result, :offense_count

    def initialize(repository)
      @repository = repository
      @linter = "Repository::Linter::#{repository.language.capitalize}".constantize.new(repository)
    end

    def run
      @linter.run
      @result = @linter.result
      @offense_count = @linter.offense_count
      self
    end

    def parse
      @linter.parse
    end
  end
end
