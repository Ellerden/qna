require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of an answer
  I'd like to be able to edit my answer
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:answer2) { create(:answer, question: question, author: user2) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'as an author edits his/her answer' do
      click_on 'Edit'

      within(".answers") do
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'as an author edits his/her answer with errors' do
      click_on 'Edit'
      within(".answers") do
        fill_in 'Body', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to edit someone elses answer' do
      within(".answer_#{answer2.id}") do
        expect(page).to have_content(answer2.body)
        expect(page).not_to have_link 'Edit'
      end
    end
  end
end