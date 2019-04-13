# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  concern :voteable do
    member do
      post :upvote
      post :downvote
    end
  end

  resources :questions, concerns: [:voteable] do
    resources :answers, concerns: [:voteable], shallow: true, except: %i[show index new] do
      patch 'set_best', on: :member
    end
  end

  resources :files, only: :destroy
  resources :awards, only: :index
end
