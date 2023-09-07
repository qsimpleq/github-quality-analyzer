# frozen_string_literal: true

class FetchRepositoriesService
  include AnyClients

  attr_reader :user, :repositories

  def initialize(user)
    @user = user
  end

  def perform
    allowed_languages = Repository.language.values
    @repositories = octokit(user).repos
                                 .select { allowed_languages.include?(_1[:language]&.downcase) }
                                 .map(&:to_h)

    Rails.cache.fetch(user_repos, expires_in: ApplicationContainer[:USER_REPOSITORIES_EXPIRE]) do
      JSON.generate(@repositories)
    end

    true
  rescue Octokit::Error
    false
  end

  def exists?
    !Rails.cache.read(user_repos).nil?
  end

  private

  def user_repos
    "user_repositories_#{@user.id}"
  end
end
