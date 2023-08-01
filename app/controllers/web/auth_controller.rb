# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      auth = request.env['omniauth.auth']
      auth_params = build_auth_params(auth)
      user = User.create_with(nickname: auth_params[:nickname], token: auth_params[:token])
                 .find_or_create_by(email: auth_params[:email])
      session[:user_id] = user.id

      redirect_to root_path, notice: t('.sign_in')
    end

    def destroy
      sign_out

      redirect_back_or_to root_path, notice: t('.sign_out')
    end

    private

    def build_auth_params(auth)
      {
        email: auth['info']['email'],
        nickname: auth['info']['nickname'],
        token: auth['credentials']['token']
      }
    end
  end
end
