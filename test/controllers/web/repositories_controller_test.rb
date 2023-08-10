# frozen_string_literal: true

require 'test_helper'
require 'octokit'

class GitHubApiWrapper
  def initialize
    @octokit_client = Octokit::Client.new
  end

  def search_repos(query)
    @octokit_client.search_repos(query)
  end
end

module Web
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @repo_one = repositories(:one)
      @user_one = users(:one)
      sign_in(@user_one)
    end

    test '#index' do
      get repositories_url
      assert_response :success
    end

    test '#new' do
      response_json = fixture_file_read('files/repositories.json')
      fixture_json_load('files/repositories.json')
      stub_client
      stub_request(:get, %r{https://api\.github\.com/search/repositories})
        .to_return(status: 200,
                   headers: { content_type: 'application/json; charset=utf-8' },
                   body: response_json)

      get new_repository_url
      assert_response :success
    end

    test '#create' do
      repo_list = fixture_json_load('files/repositories.json', symbolize_names: true)[:items]
      repo = repo_list.first
      stub_client
      stub_request(:get, %r{https://api\.github\.com/repositories/})
        .to_return(status: 200,
                   headers: { content_type: 'application/json; charset=utf-8' },
                   body: repo.to_json)

      post repositories_url(repository: { repository_github_id: repo[:id] })

      assert_redirected_to repositories_url
      assert { Repository.find_by(repository_github_id: repo[:id]) }
    end

    test '#show' do
      get repository_url(@repo_one)
      assert_response :success
    end

    def stub_client
      stub_request(:get, 'https://api.github.com/user').to_return(status: 200, body: '', headers: {})
    end
  end
end
