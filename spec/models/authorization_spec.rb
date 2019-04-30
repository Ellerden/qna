require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { belong_to(:user) }
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }
  it { should validate_uniqueness_of(:uid).scoped_to(:provider, :linked_email)
                                          .with_message('This account with this email is already taken') }

  describe '#activate_email' do
    let(:user) { create(:user, confirmed_at: nil) }
    let(:authorization) { create(:authorization, user: user, confirmed_at: nil) }

    it 'updates confirmation status of authorization and user, if it wasn not confirmed yet' do
      authorization.activate_email
      expect(authorization).to be_confirmed
      expect(user).to be_confirmed
    end
  end

  describe '#confirmed?' do
    let(:user) { create(:user) }
    let(:authorization) { create(:authorization, user: user) }

    it 'justifies that authorization is confirmed' do
      expect(authorization).to be_confirmed
    end
  end
end
