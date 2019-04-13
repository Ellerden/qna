require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }

    context 'question' do
      let(:question) { create(:question, author: user) }
      let(:question2) { create(:question, author: user2) }

      it 'justifies the user is the author' do
        expect(user).to be_author_of(question)
      end

      it 'justifies the user is NOT the author' do
        expect(user).not_to be_author_of(question2)
      end
    end
  end

  describe '#voted_for?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }

    it 'justifies user has not voted' do
      expect(user).not_to be_voted_for(question)
    end

    it 'justifies user has already voted' do
      create(:vote, voteable: question, user: user, value: 1)
      expect(user).to be_voted_for(question)
    end
  end

  describe '#previous_vote_value' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }

    it 'user did not vote - value is nil' do
      expect(user.previous_vote_value(question)).to be nil
    end

    it 'shows previous vote value' do
      expect(user).not_to be_voted_for(question)
    end

    it 'user did not vote - value is nil' do
      create(:vote, voteable: question, user: user, value: 1)
      expect(user.previous_vote_value(question)).to eq 1
    end
  end
end
