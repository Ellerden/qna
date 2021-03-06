require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated User
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do

    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question was successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'asks a question with attached files' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question and creates an award' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Award name', with: 'Award for courage'
      attach_file 'Image', "#{Rails.root}/spec/images/badge.png"
      click_on 'Ask'

      expect(page).to have_content 'Award for courage'
      expect(page).to have_css("img[src*='badge.png']")
    end

    fcontext 'multiple sessions' do
      scenario 'question appears on another users page' do
        # Capybara.using_session('user') do
        #   sign_in(user)
        #   visit questions_path
        # end

        # Capybara.using_session('guest') do
        #   visit questions_path
        # end

        Capybara.using_session('user') do
          sign_in(user)
          visit questions_path
          click_on 'Ask question'
          fill_in 'Title', with: 'Test question'
          fill_in 'Body', with: 'text text text'
          click_on 'Ask'

          expect(page).to have_content 'Your question was successfully created.'
          expect(page).to have_content 'Test question'
          expect(page).to have_content 'text text text'
        end

        Capybara.using_session('guest') do
          visit questions_path
          expect(page).to have_content 'Test question'
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to ask a question' do
      visit questions_path
      expect(page).not_to have_link 'Ask question'
    end
  end
end
