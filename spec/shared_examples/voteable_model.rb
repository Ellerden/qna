require 'rails_helper'

RSpec.shared_examples_for "voteable" do
  it { should have_many(:votes).dependent(:destroy) }
  let(:user) { create(:user) }
  let(:user2) { create(:user) }

  #let(:model) { described_class }
  #let(:resource) { create(model.to_s.underscore.to_sym, author: user) }
  let(:vote) { create :vote, user: user, voteable: resource }
  let(:vote2) { create :vote, user: user2, voteable: resource }

  describe '#score' do
    it 'User can upvote a resource - score 1' do
      vote.upvote!
      expect(resource.score).to eq 1
    end

    it 'User can downvote a resource - score -1' do
      vote.downvote!
      expect(resource.score).to eq(-1)
    end

    it 'One user upvotes, one downvotes a resource - score 0' do
      vote.upvote!
      vote2.downvote!
      expect(resource.score).to eq 0
    end
  end

  describe '#register_vote(user)' do
    let(:user3) { create(:user) }

    it 'User creates a vote' do
      expect(resource.register_vote(user3).user).to eq user3
      expect(resource.register_vote(user3)).to be_an_instance_of Vote
    end
  end

  describe '#cancel_votes(user)' do
    before do
      vote.upvote!
      resource.cancel_votes(user)
    end

    it 'User cancels his/hers previous vote' do
      expect(user.votes.find_by(voteable: resource)).to eq nil
    end
  end
end
