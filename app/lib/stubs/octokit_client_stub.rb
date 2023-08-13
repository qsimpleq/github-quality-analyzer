# frozen_string_literal: true

module Stubs
  class OctokitClientStub
    attr_reader :octokit_search_repositories, :last_response

    OCTOKIT_SEARCH_REPOSITORY_PATH = Rails.root.join('test/fixtures/files/octokit_search_repositories.json')

    def initialize(*)
      @last_response = nil
    end

    def repos
      result = load_json_fixture(OCTOKIT_SEARCH_REPOSITORY_PATH)[:items]
      set_last_response(result)
    end

    def repo(github_id)
      result = load_json_fixture(OCTOKIT_SEARCH_REPOSITORY_PATH)[:items].find { _1[:id] == github_id }
      set_last_response(result)
    end

    def search_repos(query, _options = {})
      language_filter_array = query.scan(/language:(\w+)/)&.flatten || []
      result = load_json_fixture(OCTOKIT_SEARCH_REPOSITORY_PATH)
      result[:items].select { language_filter_array.include?(_1[:language]&.downcase) }
      set_last_response(result)
    end

    # rubocop:disable Naming/AccessorMethodName
    def set_last_response(result)
      @last_response = result
      @last_response.define_singleton_method(:body) { ActiveSupport::JSON.encode(result) }
      @last_response
    end
    # rubocop:enable Naming/AccessorMethodName

    private

    def load_json_fixture(path)
      file_name = File.basename(path, '.json')
      instance_variable_name = "@#{file_name}"

      unless instance_variable_get(instance_variable_name)
        instance_variable_set(instance_variable_name, JSON.parse(File.read(path), symbolize_names: true))
      end

      instance_variable_get(instance_variable_name)
    end
  end
end
