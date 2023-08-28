# frozen_string_literal: true

class RepositoryUpdateJob < ApplicationJob
  queue_as :default

  def perform(params)
    current_user(params[:repository].user)
    repo = octokit.repo(params[:repository].github_id)

    return false if repo.nil?

    params[:repository].update(
      name: repo[:name],
      full_name: repo[:full_name],
      language: repo[:language].downcase,
      repo_created_at: repo[:created_at],
      repo_updated_at: repo[:updated_at]
    )
  end
end
