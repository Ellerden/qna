require 'rails_helper'

feature 'Signed in user can sign out', %q{
  in order to stop asking questions and leaving answers
  as unauthenticated user I'd like to sign out
} do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    click_on 'Log Out'
  end

  scenario 'Authenticated user tries to sign out' do
    expect(page).to have_content 'Signed out successfully.'
  end
end
