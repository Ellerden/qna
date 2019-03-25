require 'rails_helper'

feature 'User can see his/her awards', %q{
  In order to evaluate my contribution
  I'd like to see all awards
  Other user has granted me for best answers
} do
    describe 'Authenticated user', js: true do
      given(:user) { create(:user) }
      given(:user2) { create(:user) }
      given(:question) { create(:question, author: user) }
      given(:answer) { create(:answer, question: question, author: user) }
      given!(:award) { create(:award, question: question, answer: answer, user: user) }
      given!(:user2_award) { create(:award, question: question, answer: answer, user: user2) }

      background do 
        sign_in(user)
        visit awards_path
      end

      scenario 'sees all his/her awards' do
        expect(page).to have_content award.name
        expect(page).to have_css("img[src*='badge.png']")
      end

      scenario 'tries to see someone elses awards' do
        expect(page).to_not have_content user2_award.name
      end
    end

    scenario 'Unauthenticated user tries to see someone elses awards' do
      visit awards_path
      expect(page).to_not have_link 'Edit'
    end
end
