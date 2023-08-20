# frozen_string_literal: true

module Web
  class ChecksController < Web::ApplicationController
    before_action :require_signed_in_user!

    def show
      @repository = current_user.repositories.find(params[:repository_id])
      @check = @repository.checks.find(params[:id])
      @check_result = JSON.parse(@check.check_result, symbolize_names: true)
    end
  end
end
