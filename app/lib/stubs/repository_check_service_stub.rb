# frozen_string_literal: true

module Stubs
  class RepositoryCheckServiceStub < RepositoryCheckService
    include Stubs
    attr_reader :language

    def initialize(repository)
      super
      @language = @repository.language
      @repo_lint = Stubs::REPOSITORY["#{@language.downcase}_lint_path".to_sym]
      @repo_info = Stubs::REPOSITORY["#{@language.downcase}_repo_info_path".to_sym]
      @github_info = load_json_fixture(@repo_info)
    end

    def perform
      result_json = load_fixture(@repo_lint)
      result = load_json_fixture(@repo_lint)

      @check.run_check!
      @check.commit_id = Stubs::REPOSITORY[:commit_id]
      @check.offense_count = offense_count(result)
      @check.check_result = result_json
      @check.passed = true if @check.offense_count.zero?
      @check.mark_as_finish!
    end

    private

    def offense_count(result)
      if @language == 'ruby'
        result[:summary][:offense_count]
      else
        result.reduce(0) { |acc, element| (element[:errorCount]).positive? ? acc + element[:errorCount] : acc }
      end
    end
  end
end
