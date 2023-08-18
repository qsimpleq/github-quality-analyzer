# frozen_string_literal: true

require 'open3'

class Repository
  class Linter
    attr_accessor :linter

    def initialize(repository)
      @linter = "Repository::Linter::#{repository.language.capitalize}".constantize.new(repository)
    end

    def run
      @linter.run
    end
  end
end
