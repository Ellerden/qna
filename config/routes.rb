# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'
  resources :questions do
    resources :answers, shallow: true, except: %i[show index new] do
      patch 'set_best', on: :member
    end
  end
end
