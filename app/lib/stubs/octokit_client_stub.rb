# frozen_string_literal: true

module Stubs
  class OctokitClientStub
    include Stubs
    attr_reader :octokit_repositories, :last_response

    OCTOKIT_REPOSITORIES_PATH = Rails.root.join('test/fixtures/files/octokit_repositories.json')

    def initialize(*)
      @last_response = nil
    end

    def repos
      result = load_json_fixture(OCTOKIT_REPOSITORIES_PATH)
      set_last_response(result)
    end

    def repo(github_id)
      result = load_json_fixture(OCTOKIT_REPOSITORIES_PATH).find { _1[:id] == github_id }
      set_last_response(result)
    end

    # rubocop:disable Naming/AccessorMethodName
    def set_last_response(result)
      @last_response = result
      @last_response.define_singleton_method(:body) { ActiveSupport::JSON.encode(result) }
      @last_response
    end
    # rubocop:enable Naming/AccessorMethodName
  end
end
