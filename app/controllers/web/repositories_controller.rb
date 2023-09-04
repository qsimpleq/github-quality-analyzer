# frozen_string_literal: true

module Web
  class RepositoriesController < Web::ApplicationController
    before_action :authenticate_user!

    def index
      authorize Repository

      @repositories = current_user.repositories.order(name: :asc).page(params[:page])
    end

    def show
      @repository = current_user.repositories.find(params[:id])
      authorize @repository
    end

    def new
      @repository = Repository.new
      authorize @repository

      @available_repositories = select_available_repos(cached_fetch_repos)
    end

    def create
      @repository = current_user.repositories.find_or_initialize_by(repository_params)
      @repository.name ||= '-'
      @repository.full_name ||= '-'
      authorize @repository

      if @repository.save
        Rails.cache.delete(user_repos)
        RepositoryUpdateJob.perform_later(@repository)
        redirect_to repositories_path, notice: t('.success')
      else
        redirect_to new_repository_path, alert: t('.error')
      end
    end

    private

    def repository_params
      params.require(:repository).permit(:github_id)
    end

    def user_repos
      "user_repositories_#{current_user.id}"
    end

    def fetch_repos
      allowed_languages = Repository.language.values
      octokit.repos
             .select { allowed_languages.include?(_1[:language]&.downcase) }
             .map(&:to_h)
    end

    def cached_fetch_repos
      repos = nil
      repos_json = Rails.cache.fetch(user_repos, expires_in: ApplicationContainer[:USER_REPOSITORIES_EXPIRE]) do
        repos = fetch_repos
        JSON.generate(repos)
      end

      return JSON.parse(repos_json, symbolize_names: true) unless repos

      repos
    end

    def select_available_repos(repos)
      exists_repos = Repository.where(user_id: current_user.id).pluck(:github_id).flatten
      repos.reject { exists_repos.include?(_1[:id]) }
    end
  end
end
