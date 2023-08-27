# frozen_string_literal: true

# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  namespace :api do
    post 'checks', to: 'webhooks#github'
  end

  scope module: :web do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'auth/logout', to: 'auth#destroy'

    root 'home#show'

    resources :repositories, only: %i[index new create show] do
      scope module: :repositories do
        resources :checks, only: %i[show create]
      end
    end
  end
end
