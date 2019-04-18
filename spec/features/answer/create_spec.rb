require 'rails_helper'

feature 'User can create answer', %q{
  In order to help solve the problem
  As an authenticated User
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to answer the question on the same page with the question' do
      fill_in 'Body', with: 'text text text'
      click_on 'Create Answer'

      within '.answers' do
        expect(page).to have_content 'text text text'
      end
      expect(current_path).to eq question_path(question)
    end

    scenario 'tries to answer the question with blank' do
      click_on 'Create Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'leaves an answer with attached files' do
      fill_in 'Body', with: 'text text text'

      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    fcontext 'multiple sessions' do
      scenario 'answer appears on another users page' do
        # Capybara.using_session('user') do
        #   sign_in(user)
        #   visit questions_path
        # end

        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
          fill_in 'Body', with: 'text text text'
          click_on 'Create Answer'

          within '.answers' do
            expect(page).to have_content 'text text text'
          end
        end

        Capybara.using_session('guest') do
          within '.answers' do
            expect(page).to have_content 'text text text'
          end
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)

    expect(page).not_to have_button 'Create Answer'
  end
end
