require "rails_helper"

RSpec.describe AnswerNotifyMailer, type: :mailer do
  describe "notify" do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let!(:subscription) { create(:subscription, question: question, author: user) }
    let!(:answer) { create(:answer, question: question, author: user) }
    let(:mail) { AnswerNotifyMailer.notify(user, answer) }
    
    it "renders the headers" do
      expect(mail.subject).to eq("QnA: new answer to the question")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["mail@qna-service.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi #{user.email}")
    end

    it 'sends recently created answer' do
      expect(mail.body.encoded).to include(answer.body)
    end
  end
end
