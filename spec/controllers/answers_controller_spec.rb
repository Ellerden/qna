# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view of assigned question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end
      it 'renders to show view of assigned question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to redirect_to assigns(:question)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:other_user) { create(:user) }
    let!(:other_answer) { create(:answer, question: question, author: other_user) }

    context 'Authenticated user' do
      before { sign_in(user) }

      it 'deletes his/her own answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to show view of assigned question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question
      end

      it 'tries to delete not his/her answer' do
        delete :destroy, params: { question_id: question, id: other_answer }
        expect { delete :destroy, params: { id: other_answer } }.not_to change(Answer, :count)
        expect(response.status).to eq(403)
      end
    end

    it 'Not Authenticated user tries to delete the answer' do
      expect { delete :destroy, params: { id: answer } }.not_to change(Question, :count)
    end
  end
end
