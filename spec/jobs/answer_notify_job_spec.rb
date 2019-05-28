require 'rails_helper'

RSpec.describe AnswerNotifyJob, type: :job do
  let(:service) { double('AnswerNotifyService') }
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  before do
    allow(AnswerNotifyService).to receive(:new).and_return(service)
  end

  it 'calls AnswerNotifyService#send_notification' do
    expect(service).to receive(:send_notification).with(answer)
    AnswerNotifyJob.perform_now(answer)
  end
end
