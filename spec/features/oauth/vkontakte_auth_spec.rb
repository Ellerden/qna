require 'rails_helper'

feature 'User can sign in via social networks', %q{
  In order to not separately register on site
  I'd like to use my existing social media accounts 
  To promptly sign in and create questions/answers
} do
  
  describe 'User signs in via Vkontakte' do
    context 'New user signs in using Vkontakte for the 1st time' do
      scenario 'No email confirmation needed' do
        visit new_user_session_path
        expect(page).to have_link('Sign in with Vkontakte')
        mock_auth_hash(:vkontakte)
        click_on 'Sign in with Vkontakte'

        expect(page).to have_content('mockuser@test.com')
        expect(page).to have_content('Successfully authenticated from Vkontakte account')
      end

      context 'Email confirmation needed'
        scenario 'User does not provide email' do
          mock_auth_hash(:vkontakte, nil)
          visit new_user_session_path
          expect(page).to have_content('Sign in with Vkontakte')
          click_on 'Sign in with Vkontakte'
          expect(page).to have_content("Seems like we don't have your email - enter it below to confirm and continue.")
          click_on 'Confirm Email'

          expect(current_path).to eq root_path
        end

        scenario 'Email confirmed and user tries to log in via Vkontakte' do
          visit new_user_session_path
          mock_auth_hash(:vkontakte, nil)
          click_on 'Sign in with Vkontakte'
          expect(page).to have_content("Seems like we don't have your email - enter it below to confirm and continue.")
          fill_in 'email', with: 'test@test.com'
          click_on 'Confirm Email'
          expect(page).to have_content("Great! Now confirm your email, we've sent you a letter!")

          # WORK WITH EMAIL
          open_email('test@test.com')
          expect(current_email.subject).to eq "Confirm email after signing in via social network"
          expect(current_email).to have_content('Confirm your email')
          current_email.click_link 'CONFIRM'
          clear_emails

          expect(page).to have_content("Your account was succesfully verified. Now you can log in via Vkontakte")

          # LOG IN WITH Vkontakte after confirming
          click_on 'Sign in with Vkontakte'

          expect(page).to have_content('test@test.com')
          expect(page).to have_content('Successfully authenticated from Vkontakte account')
        end
      end
    end

    context 'User somehow already exists' do
      given!(:user) { create(:user, confirmed_at: Time.now) }

      scenario 'Already authorized via Vk user signs using Vkontakte for the 2nd time' do
        auth = mock_auth_hash(:vkontakte)
        user.update!(email: auth.info.email)
        authorization = create(:authorization, user: user, linked_email: user.email, provider: auth.provider, uid: auth.uid, confirmed_at: Time.now)
        visit new_user_session_path
        expect(page).to have_content('Sign in with Vkontakte')
        click_on 'Sign in with Vkontakte'

        expect(page).to have_content('mockuser@test.com')
        expect(page).to have_content('Successfully authenticated from Vkontakte account')
      end

      scenario 'Existing user signs in using Vkontakte for the first time' do
        auth = mock_auth_hash(:vkontakte)
        user.update!(email: auth.info.email)
        visit new_user_session_path
        expect(page).to have_content('Sign in with Vkontakte')
        click_on 'Sign in with Vkontakte'

        expect(page).to have_content('mockuser@test.com')
        expect(page).to have_content('Successfully authenticated from Vkontakte account')
      end
    end
  end
