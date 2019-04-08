require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to :voteable }
  it { should validate_presence_of :value }

  describe '#upvote!' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, author: user) }
    let!(:vote) { Vote.create(user: user2, voteable: question) }

    it 'scope increase by 1' do
      vote.value = 0
      vote.upvote!
      expect(vote.value).to eq 1
    end
  end

  describe '#downvote!' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, author: user) }
    let!(:vote) { Vote.create(user: user2, voteable: question) }

    it 'scope decrease by 1' do
      vote.value = 0
      vote.downvote!
      expect(vote.value).to eq(-1)
    end
  end
end
