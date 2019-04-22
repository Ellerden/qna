# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root 'questions#index'

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
