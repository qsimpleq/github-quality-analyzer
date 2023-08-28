# frozen_string_literal: true

require 'application_system_test_case'

class AppSystemTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  setup do
    @user = users(:user1)
  end

  test 'home#show' do
    visit root_path
    %w[courses hello more_info project_info].each do |translate|
      assert_text t("web.home.show.#{translate}")
    end
  end

  test 'repository#create' do
    sign_in(@user)
    visit root_path

    repo_name = 'hello-world-js'
    full_repo_name = "#{@user.nickname}/#{repo_name}"

    click_on t('layouts.shared.header.repositories')
    click_on t('web.repositories.index.add')

    assert { !@user.repositories.exists?(name: repo_name) }
    assert_text t('web.repositories.new.title')

    select full_repo_name, from: 'repository[github_id]'
    click_on t('web.repositories.new.submit')
    assert_text t('web.repositories.create.success')

    perform_enqueued_jobs(only: RepositoryUpdateJob)
    assert { @user.repositories.exists?(name: repo_name) }
  end
end
