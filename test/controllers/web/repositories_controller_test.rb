# frozen_string_literal: true

require 'test_helper'

module Web
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @repo_one = repositories(:repo1)
      @user1 = users(:user1)
      sign_in(@user1)
    end

    test '#index' do
      get repositories_url
      assert_response :success
    end

    test '#new' do
      get new_repository_url
      assert_response :success
    end

    test '#create' do
      github_id = 653_617_057
      post repositories_url(repository: { github_id: })

      assert_redirected_to repositories_url
      assert { Repository.find_by(github_id:) }
    end

    test '#show' do
      get repository_url(@repo_one)
      assert_response :success
    end
  end
end
