require 'rails_helper'

feature 'User can delete his/her answer', %q{
  As an author of the answer
  I want to be able to delete it
} do

  describe 'Authenticated user' do
    given(:user) { create(:user) }
    # given(:user2) { create(:user) }
    given(:question) { create(:question, author: user) }
    given!(:user_answer) { create(:answer, question: question, author: user) }

    scenario 'as author deletes answer to the question' do
      sign_in(user)
      visit question_path(question)
      
      within(".answer") do
        click_on 'Delete'
        session.refresh
        expect(current_path).to eq question_path(question)
     # within(".answer_#{user_answer.id}") do
      #   expect(page).to have_content user_answer.body
      #   click_on 'Delete'
      #   #expect(page).to have_no_content(user_answer.body)
      #   save_and_open_page
      # end
      end
      save_and_open_page
     # expect(page).to have_no_content(user_answer.body)
      expect(page).to have_content 'Your answer was successfully deleted.'
    end

    # background do
    #   sign_in(user)
    #   visit question_path(question)
    # end

    # scenario 'deletes his/her own answer to the particular question' do
    #   within(".answer_#{user_answer.id}") do
    #     expect(page).to have_content user_answer.body
    #     click_on 'Delete'

    #     expect(page).to have_no_content user_answer.body
    #   end
    # end

    # given(:user2_answer) { create(:answer, question: question, author: user2) }

    # scenario 'tries to delete someone elses answer' do
      

    #   within(".answer_#{user2_answer.id}") do
    #     expect(page).to have_content user2_answer.body
    #  # within(".answer_#{user2_answer.id}") { expect(page).to_not have_link 'Delete' }
    #   end
    # end
  end

  scenario 'Unauthenticated user tries to delete an answer' do

  end
end
