require_relative 'acceptance_helper'

feature 'User can sign in via social networks', %q{
  In order to not separately register on site
  I'd like to use my existing social media accounts 
  To promptly sign in and create questions/answers
} do
  given(:user) { create(:user) }

  describe 'User tries to sign in via Facebook' do
    scenario 'New user signs using Facebook for the 1st time' do
      visit new_user_session_path
      expect(page).to have_content('Sign in with Facebook')
      mock_auth_hash(:facebook)
      click_on 'Sign in with Facebook'
      expect(page).to have_content('Successfully authenticated from Facebook account')
    end

    scenatio 'Already authorized via FB user signs using Facebook for the 2nd time' do
    end

    scenario 'Existing user signs using Facebook' do
    end

  end

  describe 'User tries to sign in via Github' do
  end

  describe 'User tries to sign in via Vkontakte' do
  end
end
