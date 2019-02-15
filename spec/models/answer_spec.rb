require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should belong_to(:question) }

  it 'validates presence of question_id' do
    expect(Answer.new(body: '123')).to_not be_valid
  end
end
