require 'rails_helper'

feature 'User can choose the best answer', %q{
  In order to show what answer solves my problem
  As the author of the question
  I'd like to be able to pick the best answer
} do
    given(:user) { create(:user) }
    given!(:question) { create(:question, author: user) }
    given!(:answers) { create_list(:answer, 3, question: question, author: user) }

    describe 'Authenticated user' do
      context 'As an author of the question' do
        background do
          sign_in user
          visit question_path(question)
        end

        scenario 'selects only one best answer' do
          within(".answer_#{answers[2].id}") do
            click_on 'Best'
          end

          within ".answers".first do
            expect(page).to have_content answer[2].body
          end
        end
        scenario 'diselects the best answer'

        scenario 'reselects the best answer'
      end

      context 'As NOT an author of the question' do
        given(:user2) { create(:user) }

        background do
          sign_in user2
          visit question_path(question)
        end

        scenario 'sees sorted answers with the best answer at the TOP'

        scenario 'cannot choose the best answer' do
          expect(page).not_to have_link 'Best'
        end
      end

    end

    describe 'Unauthenticated user' do
      background { visit question_path(question) }

      scenario 'sees sorted answers with the best answer at the TOP'


      scenario 'cannot choose the best answer' do
        expect(page).not_to have_link 'Best'
      end
    end

end