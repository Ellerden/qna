# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }
    let(:question) { create(:question, author: user) }

    it 'creates new subscription in the database adds' do
      expect { post :create, params: { question_id: question.id } }.to change(Subscription, :count).by(1)
    end

    it 'adds subscription to the current user' do
      expect { post :create, params: { question_id: question.id } }.to change(user.subscriptions, :count).by(1)
    end
  end
end
