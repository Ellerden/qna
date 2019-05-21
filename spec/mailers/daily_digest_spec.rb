require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:mail) { DailyDigestMailer.digest(user) }
    let!(:questions) { create_list(:question, 3, author: user) }

    it "renders the headers" do
      expect(mail.subject).to eq("QnA new questions digest")
      expect(mail.to).to eq(["user1@test.com"])
      expect(mail.from).to eq(["mail@qna-service.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi #{user.email}")
    end

    it 'sends list of recently created questions' do
      expect(mail.body.encoded).to include(questions.first.title)
    end
  end
end
