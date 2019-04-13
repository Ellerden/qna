require 'rails_helper'

feature "User can vote", %q{
  As a user
  I'd like to be able to vote for answer
  Which I find usefull or unuseful
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Unauthenticated user', js: true do
    background { visit question_path(question) }

    scenario 'tries to upvote an answer' do
      within ".answer_#{answer.id} .answer-vote" do
        expect(page).not_to have_link '+'
      end
    end

    scenario 'tries to downvote an answer' do
      within ".answer_#{answer.id} .answer-vote" do
        expect(page).not_to have_link '-'
      end
    end

    scenario 'sees question score' do
      within all(".answer_#{answer.id}.answer-vote.score") { expect(page).to have_content '0' }
    end
  end

  describe 'Authenticated user', js: true do  
    context 'As NOT an author of the answer'
      background do 
        sign_in user2
        visit question_path(question)
      end

      scenario 'upvotes someone elses answer' do
        within ".answer_#{answer.id} .answer-vote" do
          click_on '+'
          expect(page).to have_content '1'
        end
      end

      scenario 'cancels his/hers previous vote' do
        within ".answer_#{answer.id} .answer-vote" do
          click_on '+'
          click_on '-'
          expect(page).to have_content '0'
        end
      end

      scenario 'downvotes someone elses answer' do
        within ".answer_#{answer.id} .answer-vote" do
          click_on '-'
          expect(page).to have_content '-1'
        end
      end

      scenario 'tries to upvote someone elses answer twice' do
        within ".answer_#{answer.id} .answer-vote" do
          click_on '+'
          click_on '+'
          expect(page).to have_content '1'
        end
      end

      scenario 'tries to downvote someone elses answer twice' do
        within ".answer_#{answer.id} .answer-vote" do
          click_on '-'
          click_on '-'
          expect(page).to have_content '-1'
        end
      end
    end

    context 'As an author of the answer' do
      background do 
        sign_in user
        visit question_path(question)
      end

      scenario 'tries to upvote his/her own answer' do
        within ".answer_#{answer.id} .answer-vote" do
          expect(page).not_to have_link '+'
        end
      end

      scenario 'tries to downvote his/her own answer' do
        within ".answer_#{answer.id} .answer-vote" do
          expect(page).not_to have_link '-'
        end
      end
    end
end
