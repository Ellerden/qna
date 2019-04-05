# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'has many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#scope sort_by_best' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:answer) { create(:answer, question: question, author: user, created_at: 1.day.ago) }
    let!(:answer2) { create(:answer, question: question, author: user, created_at: 1.hour.ago, best: true) }

    it 'shows best answer first' do
      expect(Answer.all).to match_array [answer2, answer]
    end
  end

  describe '#rate_best' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:award) { create(:award, question: question, answer: answer2, user: user) }
    let!(:answer) { create(:answer, question: question, author: user) }
    let!(:answer2) { create(:answer, question: question, author: user) }

    it 'sets answer as the best' do
      answer2.rate_best
      expect(answer2).to be_best
    end

    it 'justifies where is only one best answer' do
      answer.rate_best
      expect(answer).to be_best
      expect(answer2.best).to be false
    end

    it 'presents the award' do
      answer2.rate_best
      expect(answer2.award).to be_present
      expect(answer.award).to_not be_present
    end
  end
end
