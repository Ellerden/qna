require 'rails_helper'

feature 'User can delete his/her answer', %q{
  As an author of the answer
  I want to be able to delete it
} do

  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given(:user2) { create(:user) }
    given(:question) { create(:question, author: user) }
    given!(:answer) { create(:answer, question: question, author: user) }
    #given!(:answer2) { create(:answer, question: question, author: user) }
    given!(:user2_answer) { create(:answer, question: question, author: user2) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'deletes his/her own answer to the particular question' do
      within(".answer_#{answer.id}") do
        expect(page).to have_content answer.body
        click_on 'Delete'
        expect(page).to_not have_content answer.body
      end

      # }
      
      # expect(page).to have_content answer2.body
      #  {  }

      
      # expect(page).to have_content answer2.body
    end

    scenario 'tries to delete someone elses answer' do
      expect(page).to have_content user2_answer.body
      within(".answer_#{user2_answer.id}") { expect(page).to_not have_link 'Delete' }
    end
  end

  scenario 'Unauthenticated user tries to delete an answer' do

  end
end
