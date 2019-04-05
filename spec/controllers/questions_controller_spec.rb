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

    it 'assigns am answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'assigns new Links to @links' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new award to awards' do
      expect(assigns(:question).award).to be_a_new(Award)
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

      it 'checks if the user is an author' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question).author).to eq user
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

    context 'Author of the question' do
      before { login(user) }

      it 'deletes his/her own question' do
        expect { delete :destroy, params: { id: question } }.to change(Question,:count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Not an author of the question' do
      let(:other_user) { create(:user) }
      before { login(other_user) }

      it 'tries to delete not his/her question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 'gets forbidden status trying to delete someone elses answer' do
        delete :destroy, params: { id: question }
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:question) { create(:question, author: user) }

    before { login(user) }

    context 'Author with valid attributes' do
      it 'changes question title' do
        patch :update, params: { id: question, question: { title: 'new title' } }
        question.reload
        expect(question.title).to eq 'new title'
      end

      it 'changes question body' do
        patch :update, params: { id: question, question: { body: 'new body' } }
        question.reload
        expect(question.body).to eq 'new body'
      end

      it 'redirects to question' do
        patch :update, params: { id: question, question: { body: 'new body' } }
        expect(response).to redirect_to question
      end
    end

    context 'Author with invalid attributes' do
      it 'does not change question attributes' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }
        end.to_not change(question, :body)
      end

      it 're-renders edit form' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }
        expect(response).to render_template :edit
      end
    end

    context 'Not an author' do
      let(:other_user) { create(:user) }
      before { login(other_user) }

      it 'tries to edit not his/her question' do
        expect do
          patch :update, params: { id: question, question: { body: 'new body' } }
        end.to_not change(question, :body)
      end

      it 'gets forbidden status trying to edit someone elses question' do
        patch :update, params: { id: question, question: { body: 'new body' } }

        expect(response.status).to eq(403)
      end
    end
  end
end
