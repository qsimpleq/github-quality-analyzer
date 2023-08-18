# frozen_string_literal: true

module Web
  class RepositoriesController < Web::ApplicationController
    USER_REPOSITORIES_EXPIRE = 10 # 10.minutes
    before_action :require_signed_in_user!

    def index
      @repositories = current_user.repositories.order(name: :asc)
    end

    def show
      @repository = current_user.repositories.find(params[:id])
    end

    def new
      @repository = Repository.new
      @available_repositories = select_available_repos(cached_fetch_repos)
    end

    def create
      @repository = current_user.repositories.find_or_initialize_by(repository_params)
      @repository.name ||= '-'
      if @repository.save
        redis.del(user_repos)
        RepositoryUpdateJob.perform_later(repository: @repository, user: current_user)
        redirect_to repositories_path, notice: t('.success')
      else
        @available_repositories = select_available_repos(cached_fetch_repos)
        render :new, alert: t('.error')
      end
    end

    def check
      @repository = current_user.repositories.find(params[:id])
      RepositoryCheckJob.perform_later(repository: @repository, user: current_user)
      redirect_to repository_path(params[:id]), notice: t('.check_started')
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
      repos_json = redis.get(user_repos)
      return JSON.parse(repos_json, symbolize_names: true) if repos_json

      response = fetch_repos
      redis.set(user_repos, JSON.generate(response))
      redis.expire(user_repos, USER_REPOSITORIES_EXPIRE)
      response
    end

    def select_available_repos(repos)
      exists_repos = Repository.where(user_id: current_user.id).pluck(:github_id).flatten
      repos.reject { exists_repos.include?(_1[:id]) }
    end
  end
end
