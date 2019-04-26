class Authorization < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }

  def activate_email
    transaction do
      self.update!(confirmed_at: Time.now)
      # если это мыло уже было и подтверждено (просто так и с другой соцсетью, то ничего не делаем)
      self.user.update!(confirmed_at: Time.now) unless self.user.confirmed?
    end
  end

  def confirmed?
    self.confirmed_at?
  end
end
