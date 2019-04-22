# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }
  let!(:comment) { create(:comment, commentable: question, author: user) }

  describe '#POST create' do
    context 'Authenticated user' do
      before { login(user) }

      it 'adds comment to a question' do
        expect { post :create, params: { question_id: question.id, comment: attributes_for(:comment), format: :js } }.to change(Comment, :count).by(1)
      end

      it 'tries to add invalid comment to a question' do
        expect { post :create, params: { question_id: question.id, comment: attributes_for(:comment, :invalid), format: :js } }.not_to change(Comment, :count)
      end

      it 'checks if the user is an author' do
        post :create, params: { question_id: question.id, comment: attributes_for(:comment), format: :js }
        expect(assigns(:comment).author).to eq user
      end
    end

    context 'Unauthenticated user' do
      it 'tries to add comment to a question' do
        expect { post :create, params: { question_id: question.id, comment: attributes_for(:comment), format: :js } }.not_to change(Comment, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Author of the comment' do
      before { login(user) }

      it 'deletes his/her own comment' do
        expect { delete :destroy, params: { id: comment }, format: :js }.to change(Comment, :count).by(-1)
      end
    end

    context 'Not an author of the comment' do
      let(:other_user) { create(:user) }
      before { login(other_user) }

      it 'tries to delete not his/her comment' do
        expect { delete :destroy, params: { id: comment }, format: :js }.not_to change(Comment, :count)
      end
    end
  end
end
