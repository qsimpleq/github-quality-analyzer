# frozen_string_literal: true

module Stubs
  class RepositoryCheckJobStub < RepositoryCheckJob
    attr_reader :language

    JAVASCRIPT_LINT_PATH = Rails.root.join('test/fixtures/files/javascript_lint_with_offences.json')
    JAVASCRIPT_REPO_INFO_PATH = Rails.root.join('test/fixtures/files/javascript_repo_info.json')
    RUBY_REPO_INFO_PATH = Rails.root.join('test/fixtures/files/ruby_repo_info.json')
    RUBY_LINT_PATH = Rails.root.join('test/fixtures/files/ruby_lint.json')
    COMMIT_ID = '9340a54'

    def github_info
      @language = @repository.language
      @repo_info = "#{@language.upcase}_REPO_INFO_PATH".constantize
      @repo_lint = "#{@language.upcase}_LINT_PATH".constantize
      @github_info = JSON.parse(load_json_fixture(@repo_info), symbolize_names: true)
      self
    end

    def fetch
      @check.commit_id = COMMIT_ID

      self
    end

    def lint
      self
    end

    def parse
      result_json = load_json_fixture(@repo_lint)
      result = JSON.parse(result_json, symbolize_names: true)

      @check.offense_count = offense_count(result)
      @check.check_result = result_json
      @check.check_passed = true if @check.offense_count.zero?
      self
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
