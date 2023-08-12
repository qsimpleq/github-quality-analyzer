# frozen_string_literal: true

module Web
  class RepositoriesController < Web::ApplicationController
    before_action :require_signed_in_user!

    def index
      @repositories = Repository.includes(:user).order(name: :asc)
    end

    def show
      @repository = Repository.includes(:user).find(params[:id])
    end

    def new
      @repository = Repository.new
      @repositories = fetch_repositories_and_filter
    end

    def create
      repo = client.repo(repository_params[:github_id].to_i)

      @repository = Repository.new(name: repo[:name],
                                   language: repo[:language]&.downcase,
                                   repo_created_at: repo[:created_at],
                                   repo_updated_at: repo[:updated_at],
                                   github_id: repo[:id].to_i,
                                   user_id: current_user.id)
      if @repository.save
        redirect_to repositories_path, notice: t('.success')
      else
        @repositories = fetch_repositories_and_filter
        render :new, alert: t('.error')
      end
    end

    private

    def repository_params
      params.require(:repository).permit(:github_id)
    end

    def client
      @client ||= ApplicationContainer[:octokit_client].new(access_token: current_user.token, auto_paginate: true)
    end

    def fetch_repositories
      client.search_repos(filter_repos_by_language)[:items]
    end

    def fetch_repositories_and_filter
      exists_repos = Repository.where(user_id: current_user.id).pluck(:github_id).flatten
      fetch_repositories.reject { exists_repos.include?(_1[:id]) }
    end

    def filter_repos_by_language
      "owner:#{current_user.nickname} #{Repository.language.values.map { "language:#{_1}" }.join(' ')}"
    end
  end
end
