# frozen_string_literal: true

module Web
  module Repositories
    class ChecksController < Web::Repositories::ApplicationController
      before_action :require_signed_in_user!
      before_action :set_repository

      def show
        @check = @repository.checks.find(params[:id])
        @check_result = @check.check_result.nil? ? nil : JSON.parse(@check.check_result, symbolize_names: true)
      end

      def create
        if @repository.checks&.last&.in_process?
          return redirect_to repository_path(@repository), alert: t('.last_in_process')
        end

        ApplicationContainer[:repository_check_job].perform_later(repository: @repository)
        redirect_to repository_path(@repository), notice: t('.check_started')
      end

      private

      def set_repository
        @repository = current_user.repositories.find(params[:repository_id])
        authorize @repository
      end
    end
  end
end
