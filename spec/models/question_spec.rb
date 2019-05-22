# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  let!(:user) { create(:user) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :links }
  

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like "voteable" do
    let!(:resource) { create(:question, author: user) }
  end

  it_behaves_like "commentable"

  # describe 'reputation' do
  #   let(:question) { build(:question, author: user) }

  #   it 'calls ReputationService#calculate' do
  #     expect(ReputationJob).to receive(:perform_later).with(question)
  #     question.save!
  #   end
  # end
end
