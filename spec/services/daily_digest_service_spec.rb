require 'rails_helper'

RSpec.describe 'DailyDigestService' do
  let(:users) { create_list(:user, 3) }

  it 'sends daily digest to all users' do
    users.each do |user| 
      expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original 
      #subject.send_digest # undefined method `send_digest' for "AnswersDigestService":String
    end
    DailyDigestJob.perform_now
  end
end
