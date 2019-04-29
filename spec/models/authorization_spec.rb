require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { belong_to(:user) }
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }







  #   validates :uid, uniqueness: { scope: [:provider, :linked_email] }

  # def activate_email
  #   transaction do
  #     self.update!(confirmed_at: Time.now)
  #     # если это мыло уже было и подтверждено (просто так и с другой соцсетью, то ничего не делаем)
  #     self.user.update!(confirmed_at: Time.now) unless self.user.confirmed?
  #   end
  # end

  # def confirmed?
  #   self.confirmed_at?
  # end
end
