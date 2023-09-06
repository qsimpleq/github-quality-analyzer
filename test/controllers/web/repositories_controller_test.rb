# frozen_string_literal: true

require 'test_helper'

module Web
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @repo = repositories(:repo1)
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

      assert_enqueued_with(job: RepositoryUpdateJob, args: [repository])
      perform_enqueued_jobs

      github_repo = octokit(current_user).repo(github_id)
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
      get repository_path(@repo)
      assert_response :success
    end

    test '#check ruby' do
      assert_equal('ruby', @repo.language)

      get repository_path(@repo)

      post repository_checks_path(@repo)
      assert_redirected_to repository_path(@repo)
      assert_equal flash[:notice], t('.check_started')

      assert_enqueued_with(job: ApplicationContainer[:repository_check_job], args: [@repo])
      perform_enqueued_jobs

      check = @repo.checks.last
      assert { check.aasm_state == 'finished' }
      assert { check.offense_count.zero? }
      assert { check.passed }
    end

    test '#check javascript' do
      @repo = repositories(:repo2)

      assert_equal('javascript', @repo.language)

      get repository_path(@repo)

      post repository_checks_path(@repo)
      assert_redirected_to repository_path(@repo)
      assert_equal flash[:notice], t('.check_started')

      assert_enqueued_with(job: ApplicationContainer[:repository_check_job], args: [@repo])
      perform_enqueued_jobs

      check = @repo.checks.last
      assert { check.aasm_state == 'finished' }
      assert { check.offense_count.zero? }
      assert { check.passed }
    end
  end
end
