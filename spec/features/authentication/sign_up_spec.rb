require 'rails_helper'
feature 'User can sign in', %q{
  in order to ask question
  as an unauthenticated User
  i'd like to be able to sign in
} do
    given(:user) { create(:user) }

    background do
      visit root_path
      click_on 'Sign Up'
    end

    scenario 'Unregistred user tries to register' do
      fill_in 'Email', with: 'unregistred_email@test.com'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '123456'
      click_on 'Sign up'
      expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'
    end

    scenario 'User tries to register with error' do
      click_on 'Sign up'
      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
    end

    scenario 'User tries to register and does not confirm a password' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Sign up'
      expect(page).to have_content "Password confirmation doesn't match Password"
    end

    scenario 'Registred user tries to register' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password
      click_on 'Sign up'
      expect(page).to have_content 'Email has already been taken'
    end
end
