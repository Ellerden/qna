require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:votes) }
  it { should have_many(:awards) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('Our service for find for oauth') }

    it 'calls FindForOuathService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '.find_or_init_skip_confirmation' do
    let!(:user) { create(:user) }
    
    it 'finds existing user' do
      expect(User.find_or_init_skip_confirmation(user.email)).to eq user
    end

    it 'initializes new user' do
      expect { User.find_or_init_skip_confirmation('new@email.com') }.to change(User, :count).by(1)
    end

    it 'it sends no confirmation letter to new user' do
      new_user = User.find_or_init_skip_confirmation('new@email.com')
      expect(new_user).to be_confirmed
    end
  end

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

  describe '#subscribed_to?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:subscription) { create(:subscription, question: question, author: user) }

    it 'justifies user is subscribed to the question' do
      expect(user).to be_subscribed_to(question)
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

    it 'user did not vote - resource is nil' do
      expect(user).not_to be_voted_for(question)
    end

    it 'user did vote - show previous vote value' do
      create(:vote, voteable: question, user: user, value: 1)
      expect(user.previous_vote_value(question)).to eq 1
    end
  end
end
