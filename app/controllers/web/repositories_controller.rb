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
      @repositories = fetch_repositories
      # File.write(Rails.root.join('test/fixtures/files/repositories.json'), client.last_response.body.to_json)
      # client.repos
      # File.write(Rails.root.join('test/fixtures/files/repositories1.json'), client.last_response.body.to_json)
    end

    def create
      repo = client.repo(repository_params[:repository_github_id].to_i)
      @repository = Repository.new(name: repo[:name],
                                   language: repo[:language]&.downcase,
                                   repo_created_at: repo[:created_at],
                                   repo_updated_at: repo[:updated_at],
                                   repository_github_id: repo[:id].to_i,
                                   user_id: current_user.id)
      if @repository.save
        redirect_to repositories_path, notice: t('.success')
      else
        @repositories = fetch_repositories
        render :new, alert: t('.error')
      end
    end

    private

    def repository_params
      params.require(:repository).permit(%i[repository_github_id])
    end

    def client
      @client ||= Octokit::Client.new access_token: current_user.token, auto_paginate: true
    end

    def fetch_repositories
      client.search_repos(filter_repos_by_language(client)).items

      # pp JSON.parse(client.search_repos(filter_repos_by_language(client)), symbolize_names: true)
    end

    def fetch_repositories_non_exists
      Repository.where(user_id: current_user.id).pluck(:repository_github_id)
      # fetch_repositories
    end

    def filter_repos_by_language(client)
      "owner:#{current_user.nickname} #{Repository.language.values.map { "language:#{_1}" }.join(' ')}"
    end
  end
end
