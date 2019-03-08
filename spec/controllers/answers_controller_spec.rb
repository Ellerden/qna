# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view of assigned question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
      end

      it 'checks if the user is an author' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(assigns(:answer).author).to eq user
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-renders show view of assigned question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Author of the answer' do
      before { login(user) }

      it 'deletes his/her own answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to show view of assigned question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question
      end
    end

    context 'Not an author of the answer' do
      let(:other_user) { create(:user) }
      before { login(other_user) }

      it 'tries to delete not his/her answer' do
        expect { delete :destroy, params: { id: answer } }.not_to change(Answer, :count)
      end

      it 'gets forbidden status trying to delete someone elses answer' do
        delete :destroy, params: { id: answer }

        expect(response.status).to eq(403)
      end
    end
  end
end
