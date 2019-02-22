# frozen_string_literal: true

Rails.application.routes.draw do
  root 'questions#index'
  resources :questions do
    resources :answers, shallow: true, except: %i[show index]
  end
end
