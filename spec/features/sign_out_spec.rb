require 'rails_helper'

feature 'Signed in user can sign out', %q{
  in order to stop asking questions and leaving answers
  as unauthenticated user I'd like to sign out
} do
  given(:user) { create(:user) }

  background { visit destroy_user_session_path }

  scenario 'Authenticated user tries to sign out' do
    # fill_in 'Email', with: user.email
    # fill_in 'Password', with: user.password
    # click_on 'Log in'
    # save_and_open_page
    expect(page).to have_content 'Signed out successfully.'
    # проверить это
  end

  scenario 'Unregistered user tries to sign in' do
    # fill_in 'Email', with: 'wrong@test.com'
    # fill_in 'Password', with: '12345678'
    # click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end


 # destroy_user_session DELETE /users/sign_out(.:format) 
 #   devise/sessions#destroy