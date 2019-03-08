require 'rails_helper'

feature 'User can delete his/her answer', %q{
  As an author of the answer
  I want to be able to delete it
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:answer2) { create(:answer, question: question, author: user2) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'as author deletes answer to the question' do
      within(".answer_#{answer.id}") do
        expect(page).to have_content(answer.body)
        click_on 'Delete'
      end
      expect(page).to have_no_content(answer.body)
      expect(page).to have_content 'Your answer was successfully deleted.'
    end

    scenario 'tries to delete someone elses answer' do
      within(".answer_#{answer2.id}") do
        expect(page).to have_content(answer2.body)
        expect(page).not_to have_link 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete an answer' do
    visit question_path(question)
    expect(page).not_to have_link 'Delete'
  end
end
