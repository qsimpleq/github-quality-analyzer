# frozen_string_literal: true

module Web
  class ApplicationController < ApplicationController
    include AuthManager
    include Pundit::Authorization
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    helper_method %i[back_path current_user sign_in signed_in? sign_out]

    private

    def back_path(**params)
      params[:action_name] ||= action_name
      params[:controller_name] ||= controller_name

      if %w[new show].include?(params[:action_name])
        url_for(controller: params[:controller_name], action: :index, only_path: true)
      elsif %w[edit update].include?(params[:action_name])
        url_for(controller: params[:controller_name], action: :show, only_path: true)
      else
        params[:default_path] || request.referer || request.path
      end
    end
  end
end
