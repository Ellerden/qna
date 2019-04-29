require 'rails_helper'

RSpec.describe OauthMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:auth) { create(:authorization, user: user) }
  let(:mail) { OauthMailer.send_confirmation_letter(auth) }

  it 'renders headers' do
    expect(mail.subject).to eq 'Confirm email after signing in via social network'
    expect(mail.from).to eq(['mail@qna-portal.com'])
    expect(mail.to).to eq([user.email])
  end

  it 'renders body' do
    expect(mail.body.encoded).to match('Confirm your email')
  end
end
