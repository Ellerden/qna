# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  root 'questions#index'

  authenticate :user, lambda { |u| u.admin? } do 
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create destroy update], shallow: true do
        resources :answers, only: %i[index show create]
      end
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  devise_scope :user do
    post "/confirm_email", to: "oauth_callbacks#confirm_email", as: :request_email
    get "/verify_email", to: "oauth_callbacks#verify_email", as: :verify_email
  end

  mount ActionCable.server => '/cable'

  concern :voteable do
    member do
      post :upvote
      post :downvote
    end
  end

  concern :commentable do
    resources :comments, only: %i[create destroy]
  end

  resources :questions, concerns: [:voteable, :commentable] do
    resources :answers, concerns: [:voteable, :commentable], shallow: true, except: %i[show index new] do
      patch 'set_best', on: :member
    end
  end

  resources :files, only: :destroy
  resources :awards, only: :index
  resources :subscriptions, only: %i[create destroy]
end
