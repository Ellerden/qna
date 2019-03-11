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
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)

    expect(page).not_to have_button 'Create Answer'
  end
end
