require 'rails_helper'

feature 'User can delete his/her question', %q{
  As an author of the question
  I want to be able to delete it
} do
    given(:user) { create(:user) }
    given(:user2) { create(:user) }
    given!(:question) { create(:question, author: user) }
    given(:answers) { create_list(:answer, 3, question: question, author: user) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'as author deletes his/her own question' do
      visit question_path(question)

      within(".question") do
        expect(page).to have_content question.body
        click_on 'Delete'
        expect(current_path).to eq questions_path
      end
      expect(page).to have_content 'Your question was successfully deleted.'
      expect(page).not_to have_content question.title
    end

    given(:question2) { create(:question, author: user2) }

    scenario 'tries to delete someone elses question' do 
      visit question_path(question2)

      within(".question") do
        expect(page).to have_content question2.body
        expect(page).not_to have_content 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete an answer' do
    visit question_path(question)

    within(".question") do
      expect(page).to have_content question.body
      expect(page).not_to have_content 'Delete'
    end
  end
end
