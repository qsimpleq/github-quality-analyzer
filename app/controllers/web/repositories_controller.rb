# frozen_string_literal: true

module Web
  class RepositoriesController < Web::ApplicationController
    USER_REPOSITORIES_EXPIRE = 10.minutes
    before_action :require_signed_in_user!

    def index
      @repositories = current_user.repositories.order(name: :asc)
    end

    def show
      @repository = current_user.repositories.find(params[:id])
    end

    def new
      @repository = Repository.new
      @available_repositories = select_available_repos(fetch_repos)
    end

    def create
      @repository = current_user.repositories.find_or_initialize_by(repository_params)
      if @repository.save
        redis.del(user_repos)
        RepositoryUpdateJob.perform_later(repository: @repository, user: current_user)
        redirect_to repositories_path, notice: t('.success')
      else
        @available_repositories = select_available_repos(fetch_repos)
        render :new, alert: t('.error')
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
      repos_json = redis.get(user_repos)
      unless repos_json
        response = octokit.search_repos(filter_repos_by_language)
        redis.set(user_repos, octokit.last_response.body)
        redis.expire(user_repos, USER_REPOSITORIES_EXPIRE)
        return response[:items]
      end

      JSON.parse(repos_json, symbolize_names: true)[:items]
    end

    def select_available_repos(repo)
      exists_repos = Repository.where(user_id: current_user.id).pluck(:github_id).flatten
      repo.reject { exists_repos.include?(_1[:id]) }
    end

    def filter_repos_by_language
      "owner:#{current_user.nickname} #{Repository.language.values.map { "language:#{_1}" }.join(' ')}"
    end
  end
end
