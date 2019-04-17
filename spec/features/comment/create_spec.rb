require 'rails_helper'

feature 'User can comment question or answer ', %q{
  In order to specify some details
  Or leave a remark
  As an authenticated User
  I'd like to be able to leave a comment
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to leave comment to the question' do
      within '.question' do
        fill_in 'Your comment', with: 'text text text'
        click_on 'Create Comment'
        wait_for_ajax

        expect(page).to have_content 'text text text'
      end
    end

    scenario 'tries to leave blank comment to the question' do
      within '.question' do
        click_on 'Create Comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Unauthenticated user tries to leave comment to the question' do
    visit question_path(question)

    expect(page).not_to have_button 'Create Comment'
  end
end
