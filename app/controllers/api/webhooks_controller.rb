# frozen_string_literal: true

module Api
  class WebhooksController < Api::ApplicationController
    skip_before_action :verify_authenticity_token

    def github
      case request.headers['X-GitHub-Event']
      when 'ping'
        ping
      when 'push', nil
        push(repository_params[:id])
      else
        render json: { '501': :not_implemented.to_s.humanize }, status: :not_implemented
      end
    end

    private

    def ping
      head :ok
      # render json: { '200': 'Ok', application: Rails.application.class.module_parent_name }, status: :ok
    end

    def push(github_id)
      repository = Repository.find_by(github_id:)
      return render json: { '404': :not_found.to_s.humanize }, status: :not_found if repository.nil?
      return render json: { '409': :conflict.to_s.humanize }, status: :conflict if repository.checks.last&.in_process?

      RepositoryCheckJob.perform_later(repository:)

      render json: { '200': :ok.to_s.humanize }, status: :ok
    end

    def repository_params
      params.require('repository').permit('id')
    end
  end
end
