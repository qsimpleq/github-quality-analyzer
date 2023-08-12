# frozen_string_literal: true

module Stubs
  class OctokitClientStub
    attr_reader :octokit_search_repositories

    OCTOKIT_SEARCH_REPOSITORY_PATH = Rails.root.join('test/fixtures/files/octokit_search_repositories.json')

    def initialize(*); end

    def repos
      load_json_fixture(OCTOKIT_SEARCH_REPOSITORY_PATH)[:items]
    end

    def repo(github_id)
      load_json_fixture(OCTOKIT_SEARCH_REPOSITORY_PATH)[:items].find { _1[:id] == github_id }
    end

    def search_repos(query, _options = {})
      language_filter_array = query.scan(/language:(\w+)/)&.flatten || []
      result = load_json_fixture(OCTOKIT_SEARCH_REPOSITORY_PATH)
      result[:items].select { language_filter_array.include?(_1[:language]&.downcase) }
      result
    end

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
