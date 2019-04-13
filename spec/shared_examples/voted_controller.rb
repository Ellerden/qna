require 'rails_helper'

RSpec.shared_examples_for "voted" do
  describe '#POST upvote' do
    let(:user2) { create(:user) }

    context 'Authenticated user' do
      before { login(user2) }

      it 'tries to vote up for someone elses resource (answer/question)' do
        post :upvote, params: { id: resource }
        expect(resource.score).to eq 1
      end

      it 'tries to vote up his/her own resource (answer/question)' do
        login(user)

        post :upvote, params: { id: resource }
        expect(resource.score).to eq 0
      end
    end

    context 'Unauthenticated user' do
      it 'tries to vote up for someones resource (answer/question)' do
        post :upvote, params: { id: resource }
        expect(resource.score).to eq 0
      end
    end

    it 'responce must be JSON' do
      login(user2)
      post :upvote, params: { id: resource }

      expect(JSON.parse(response.body)['score']).to eq resource.score
    end
  end

  describe '#POST downvote' do
    let(:user2) { create(:user) }

    context 'Authenticated user' do
      before { login(user2) }

      it 'tries to vote down for someone elses resource (answer/question)' do
        post :downvote, params: { id: resource }
        expect(resource.score).to eq -1
      end

      it 'tries to vote down his/her own resource (answer/question)' do
        login(user)

        post :downvote, params: { id: resource }
        expect(resource.score).to eq 0
      end
    end

    context 'Unauthenticated user' do
      it 'tries to vote down for someones resource (answer/question)' do
        post :downvote, params: { id: resource }
        expect(resource.score).to eq 0
      end
    end

    it 'responce must be JSON' do
      login(user2)
      post :downvote, params: { id: resource }

      expect(JSON.parse(response.body)['score']).to eq resource.score
    end
  end
end
