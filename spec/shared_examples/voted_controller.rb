require 'rails_helper'

RSpec.shared_examples_for "voted" do
  let(:user) { create(:user) }
  let(:resource) { create(:question, author: user) }
  describe '#POST upvote' do


    # let(:model) { described_class }
    # let(:user) { create(:user) }
    # let(:resource) { create(model.to_s.underscore.to_sym, author: user) }

    context 'Authenticated user' do
      # let(:user) { create(:user) }
      let(:user2) { create(:user) }

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
  end

  describe '#POST downvote' do
    context 'Authenticated user' do
      # let(:user) { create(:user) }
      let(:user2) { create(:user) }

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
  end

  #   def upvote
  #   used_as_cancelation?(:up) ? vote(:cancel) : vote(:up)
  # end

  # def downvote
  #   used_as_cancelation?(:down) ? vote(:cancel) : vote(:down)
  # end


end
