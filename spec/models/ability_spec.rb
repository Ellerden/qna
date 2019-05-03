# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:user2) { create :user }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :update, create(:question, author: user), author: user }
      it { should_not be_able_to :update, create(:question, author: user2), author: user }
      it { should be_able_to :destroy, create(:question, author: user), author: user }
      it { should_not be_able_to :destroy, create(:question, author: user2), author: user }
      it { should be_able_to :set_best, create(:question, author: user), author: user }
      it { should_not be_able_to :set_best, create(:question, author: user2), author: user }
      it { should be_able_to :upvote, create(:question, author: user2), author: user }
      it { should_not be_able_to :upvote, create(:question, author: user), author: user }
      it { should be_able_to :downvote, create(:question, author: user2), author: user }
      it { should_not be_able_to :downvote, create(:question, author: user), author: user }
    end

    context 'Answer' do
      let(:question) { create(:question, author: user) }

      it { should be_able_to :create, Answer }
      it { should be_able_to :update, create(:answer, question: question, author: user), author: user }
      it { should_not be_able_to :update, create(:answer, question: question, author: user2), author: user }
      it { should be_able_to :destroy, create(:answer, question: question, author: user), author: user }
      it { should_not be_able_to :destroy, create(:answer, question: question, author: user2), author: user }
      it { should be_able_to :set_best, create(:answer, question: question, author: user), author: user }
      it { should_not be_able_to :set_best, create(:answer, question: question, author: user2), author: user }
      it { should be_able_to :upvote, create(:answer, question: question, author: user2), author: user }
      it { should_not be_able_to :upvote, create(:answer, question: question, author: user), author: user }
      it { should be_able_to :downvote, create(:answer, question: question, author: user2), author: user }
      it { should_not be_able_to :downvote, create(:answer, question: question, author: user), author: user }
    end

    context 'Comment' do
      let(:question) { create(:question, author: user) }

      it { should be_able_to :create, Comment }
      it { should be_able_to :update, create(:comment, commentable: question, author: user), author: user }
      it { should_not be_able_to :update, create(:comment, commentable: question, author: user2), author: user }

      it { should be_able_to :destroy, create(:comment, commentable: question, author: user), author: user }
      it { should_not be_able_to :destroy, create(:comment, commentable: question, author: user2), author: user }
    end
  end
end
