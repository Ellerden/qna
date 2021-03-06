# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }

  describe 'POST #create' do
    before { login(user) }
    
    it 'creates new subscription in the database' do
      expect { post :create, params: { question_id: question.id }, format: :js }.to change(Subscription, :count).by(1)
    end

    it 'adds subscription to the current user' do
      expect { post :create, params: { question_id: question.id }, format: :js }.to change(user.subscriptions, :count).by(1)
    end

    it 'adds subscription to the current question' do
      expect { post :create, params: { question_id: question.id }, format: :js }.to change(question.subscriptions, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:subscription) { create(:subscription, question: question, author: user) }
    let(:user2) { create(:user) }
    let(:subscription2) { create(:subscription, question: question, author: user2) }

    it 'deletes his/her own subscription from the database' do
      expect { delete :destroy, params: { id: subscription }, format: :js }.to change(Subscription, :count).by(-1)
    end

    it 'tries to delete someone elses subscription from the database' do
      expect { delete :destroy, params: { id: subscription2 }, format: :js }.not_to change(Subscription, :count)
    end
  end
end
