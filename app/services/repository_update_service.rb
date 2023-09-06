# frozen_string_literal: true

class RepositoryUpdateService
  include AnyClients
  def perform(repository)
    data = octokit(repository.user).repo(repository.github_id)

    return false if data.nil?

    repository.update(
      name: data[:name],
      full_name: data[:full_name],
      git_url: data[:git_url],
      language: data[:language].downcase,
      repo_created_at: data[:created_at],
      repo_updated_at: data[:updated_at],
      ssh_url: data[:ssh_url]
    )
  end
end
