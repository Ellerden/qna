require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:question2) { create(:question, author: user2) }

    context 'question' do
      it 'justifies the user is the author' do
        expect(user).to be_author_of(question)
      end

      it 'justifies the user is NOT the author' do
        expect(user).not_to be_author_of(question2)
      end
    end

    context 'answer' do
      let!(:answer) { create(:answer, question: question, author: user) }
      let!(:answer2) { create(:answer, question: question, author: user2) }

      it 'justifies the user is the author' do
        expect(user).to be_author_of(answer)
      end

      it 'justifies the user is NOT the author' do
        expect(user).not_to be_author_of(answer2)
      end
    end
  end
end
