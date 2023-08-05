# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      auth = request.env['omniauth.auth']
      auth_params = build_auth_params(auth)

      user = User.find_or_initialize_by(email: auth_params[:email])
      user.nickname = auth_params[:nickname]
      user.token = auth_params[:token]

      if user.save
        sign_in user
        redirect_to root_path, notice: t('.sign_in')
      else
        redirect_to root_path, alert: "#{t('.error')}: #{user.errors.full_messages.join(', ')}"
      end
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
