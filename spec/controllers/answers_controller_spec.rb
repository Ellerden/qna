# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }

  it_behaves_like "voted" do
    let(:user) { create(:user) }
    let!(:resource) { create(:answer, question: question, author: user) }
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js  }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js  }
        expect(response).to render_template :create
      end

      it 'checks if the user is an author' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js  }
        expect(assigns(:answer).author).to eq user
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Author of the answer' do
      before { login(user) }

      it 'deletes his/her own answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'Not an author of the answer' do
      let(:other_user) { create(:user) }
      before { login(other_user) }

      it 'tries to delete not his/her answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.not_to change(Answer, :count)
      end

      it 'redirected to root with authentication error message trying to delete someone elses answer' do
        delete :destroy, params: { id: answer }

        expect(response.status).to eq(302)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, author: user) }
    before { login(user) }

    context 'Author with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body'}, format: :js }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
        expect(response).to render_template :update
      end
    end

    context 'Author with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'NOT an author tries to update the answer' do
      let(:other_user) { create(:user) }
      before { login(other_user) }

      it 'cannot change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body'}, format: :js }
        answer.reload
        expect(answer.body).not_to eq 'new body'
      end
    end
  end

  describe 'POST #best' do
    context 'Author of the question' do
      before { login(user) }

      it 'tries to select one best answer' do
        post :set_best, params: { id: answer, format: :js }
        answer.reload
        expect(answer.best).to be true
      end

      it 'renders ranked answers' do
        post :set_best, params: { id: answer, format: :js }
        expect(response).to render_template :set_best
      end
    end

    context 'NOT an author of the question' do
      let(:other_user) { create(:user) }
      before { login(other_user) }

      it 'tries to select the best answer' do
        post :set_best, params: { id: answer, format: :js }
        answer.reload
        expect(answer.best).to be false
      end
    end
  end
end
