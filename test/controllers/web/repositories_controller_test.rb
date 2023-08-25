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
      get repositories_path
      assert_response :success
    end

    test '#new' do
      get new_repository_path
      assert_response :success
    end

    test '#create success' do
      github_id = 653_617_057
      post repositories_path(repository: { github_id: })

      assert_redirected_to repositories_path
      assert { Repository.find_by(github_id:) }
      assert_equal flash[:notice], t('.success')

      repository = Repository.last

      assert_enqueued_with(job: RepositoryUpdateJob, args: [{ repository: }])
      perform_enqueued_jobs

      github_repo = octokit.repo(github_id)
      repository.reload
      assert { repository.url == github_repo[:html_url] }
      assert { repository.name == github_repo[:name] }
      assert { repository.language == github_repo[:language].downcase }
      assert { repository.repo_created_at == github_repo[:created_at] }
      assert { repository.repo_updated_at == github_repo[:updated_at] }
    end

    test '#create failed' do
      post repositories_path(repository: { github_id: '' })

      assert_redirected_to new_repository_path
      assert_equal flash[:alert], t('.error')
    end

    test '#show' do
      get repository_path(@repo_one)
      assert_response :success
    end

    test '#check' do
      get repository_path(@repo_one)

      patch check_repository_path(@repo_one)
      assert_redirected_to repository_path(@repo_one)
      assert_equal flash[:notice], t('.check_started')
    end
  end
end
