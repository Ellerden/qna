require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:votes) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email } ) }
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' } ) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
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
