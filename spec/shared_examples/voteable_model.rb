require 'rails_helper'

RSpec.shared_examples_for "voteable" do
  it { should have_many(:votes).dependent(:destroy) }
  let(:user) { create(:user) }
  let(:user2) { create(:user) }

  #let(:model) { described_class }
  #let(:resource) { create(model.to_s.underscore.to_sym, author: user) }
  # let(:vote) { create :vote, user: user, voteable: resource }

  describe '#score' do
    it 'User can upvote a resource - score 1' do
      resource.upvote!(user)
      expect(resource.score).to eq 1
    end

    it 'User can downvote a resource - score -1' do
      resource.downvote!(user)
      expect(resource.score).to eq(-1)
    end

    it 'One user upvotes, one downvotes a resource - score 0' do
      resource.upvote!(user)
      resource.downvote!(user)
      expect(resource.score).to eq 0
    end
  end

  describe '#upvote' do
    it 'User can increase a resource score by 1' do
      resource.upvote!(user)
      expect(resource.score).to eq 1
      expect(resource.downvote!(user)).to be_an_instance_of Vote
    end
  end

  describe '#downvote' do
    it 'User can descrease a resource score by 1' do
      resource.downvote!(user)
      expect(resource.score).to eq -1
      expect(resource.downvote!(user)).to be_an_instance_of Vote
    end
  end

  describe '#cancel_votes(user)' do
    before do
      resource.upvote!(user)
      resource.cancel_votes(user)
    end

    it 'User cancels his/hers previous vote' do
      expect(user.votes.find_by(voteable: resource)).to eq nil
    end
  end
end
