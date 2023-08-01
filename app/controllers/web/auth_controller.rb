# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      auth = request.env['omniauth.auth']

      user = User.find_by_provider_and_uid(auth) || User.create_with_omniauth(auth)
      session[:user_id] = user.id

      redirect_to root_path, notice: t('action.log_in')
    end

    def destroy
      sign_out

      redirect_back_or_to root_path, notice: t('actions.log_out')
    end
  end
end
