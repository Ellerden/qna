# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  let!(:user) { create(:user) }

  it { should belong_to(:author).class_name('User') }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :links }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like "voteable" do
    let!(:resource) { create(:question, author: user) }
  end

  it_behaves_like "commentable"

  let!(:recent_question) { create(:question, author: user) }
  let!(:old_question) { create(:question, author: user, created_at: 1.day.ago) }

  describe ".scope today" do
    it 'shows question created today' do
      expect(Question.today.to_a).to match_array [recent_question]
    end
  end
end

  # describe 'reputation' do
  #   let(:question) { build(:question, author: user) }

  #   it 'calls ReputationService#calculate' do
  #     expect(ReputationJob).to receive(:perform_later).with(question)
  #     question.save!
  #   end
  # end
