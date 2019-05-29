require 'rails_helper'

RSpec.describe "AnswerNotifyService" do
  let(:users) { create_list(:user, 2) }
  let!(:question) {create(:question, author: users.first) }
  let!(:answer) { create(:answer, question: question, author: users.first) }
  let!(:subscription1) { create(:subscription, question: question, author: users.first) }
  let!(:subscription2) { create(:subscription, question: question, author: users.second) }

  it 'sends update about new answer to all subscribed to the question users' do
    question.subscriptions.each do |subscription|
      expect(AnswerNotifyMailer).to receive(:notify).with(subscription.author, answer).and_call_original
    end
    AnswerNotifyJob.perform_now(answer)
  end
end
