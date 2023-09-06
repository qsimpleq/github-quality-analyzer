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
        render_json :not_implemented
      end
    end

    private

    def ping
      render_json :ok, application: Rails.application.class.module_parent_name
    end

    def push(github_id)
      repository = Repository.find_by(github_id:)
      return render_json :not_found if repository.nil?
      return render_json :conflict if repository.checks.last&.checking?

      ApplicationContainer[:repository_check_job].perform_later(repository)

      render_json :ok
    end

    def repository_params
      params.require('repository').permit('id')
    end

    def render_json(status, **)
      if status.to_s.match?(/^\d+$/)
        status_code = status.to_s
        status_name = Rack::Utils::HTTP_STATUS_CODES[status].downcase.underscore.tr(' ', '_').to_sym
      else
        status_code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status].to_s
        status_name = status
      end

      render json: { status_code => status_name.to_s.humanize }.merge(**), status: status_name
    end
  end
end
