require 'rails_helper'

feature "User can vote", %q{
  As a user
  I'd like to be able to vote for question
  Which I find usefull or unuseful
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Unauthenticated user', js: true do
    background { visit question_path(question) }

    scenario 'tries to upvote a question' do
      within '.question-vote' do
        click_on '+'
        expect(page).to have_content '0'
      end
    end

    scenario 'tries to downvote a question' do
      within '.question-vote' do
        click_on '-'
        expect(page).to have_content '0'
      end
    end

    scenario 'sees question score' do
      within all('.question-vote.score') { expect(page).to have_content '0' }
    end
  end

  describe 'Authenticated user', js: true do
    
    context 'As NOT an author of the question'
      background do 
        sign_in user2
        visit question_path(question)
      end

      scenario 'upvotes someone elses question' do
        within '.question-vote' do
          click_on '+'
          expect(page).to have_content '1'
        end
      end

      scenario 'cancels his/hers previous vote' do
        within '.question-vote' do
          click_on '+'
          click_on '-'
          expect(page).to have_content '0'
        end
      end

      scenario 'downvotes someone elses question' do
        within '.question-vote' do
          click_on '-'
          expect(page).to have_content '-1'
        end
      end

      scenario 'tries to upvote someone elses question twice' do
        within '.question-vote' do
          click_on '+'
          click_on '+'
          expect(page).to have_content '1'
        end
      end

      scenario 'tries to downvote someone elses question twice' do
        within '.question-vote' do
          click_on '-'
          click_on '-'
          expect(page).to have_content '-1'
        end
      end
    end

    context 'As an author of the question' do
      background do 
        sign_in user
        visit question_path(question)
      end

      scenario 'tries to upvote his/her own question' do
        within '.question-vote' do
          expect(page).not_to have_link '+'
        end
      end

      scenario 'tries to downvote his/her own question' do
        within '.question-vote' do
          expect(page).not_to have_link '-'
        end
      end
    end
  end
