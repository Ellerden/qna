# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, author: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:answers) { create_list(:answer, 2, question: question, author: user) }
    before { get :show, params: { id: question } }

    # it 'assigns the requested question to @question' do
    #   expect(assigns(:question)).to eq question
    # end
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }
    # it 'assigns the requested question to @question' do
    #   expect(assigns(:question)).to be_a_new(Question)
    # end
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end
      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, author: user) }
    let(:other_user) { create(:user) }
    let!(:other_question) { create(:question, author: other_user) }

    context 'Authenticated user' do
      before { login(user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question,:count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end

      it 'tries to delete not his/her question' do
        delete :destroy, params: { question_id: question, id: other_question }
        expect { delete :destroy, params: { id: other_question } }.not_to change(Question, :count)
        expect(response.status).to eq(403)
      end
    end

    it 'Not Authenticated user tries to delete the answer' do
      expect { delete :destroy, params: { id: other_question } }.not_to change(Question, :count)
    end
  end
end
