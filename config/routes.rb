# frozen_string_literal: true

Rails.application.routes.draw do
  root 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  devise_scope :user do
    post "/confirm_email", to: "oauth_callbacks#confirm_email"
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
end
