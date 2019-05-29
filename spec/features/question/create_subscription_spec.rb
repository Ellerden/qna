require 'rails_helper'

feature 'User can subscribe to a question', %q{
  In order to quickly get new answers
  As an question author or just an ordinary user
  I'd like to be able to subscribe to the question
  To get notifications
} do
    given(:user) { create(:user) }
    given(:user2) { create(:user) }
    given(:question) { create(:question, author: user2) }

    describe 'Authorized user', js: true do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'subscribes to the question' do
        within('.question .subscriptions') do
          click_on 'Subscribe'
          wait_for_ajax
        end

        expect(page).to have_content "Subscription created! Now you'll receive all answer updates"
      end

      scenario 'tries to subscribe to the question the second time' do
        within('.question .subscriptions') do
          click_on 'Subscribe'
          wait_for_ajax

          expect(page).not_to have_button('Subscribe')
          expect(page).to have_button('Unsubscribe')
        end
      end
    end

    describe 'Author of the question' do
      background do
        sign_in(user2)
        visit question_path(question)
      end

      scenario 'sees unsubscribe button by subscribed by default' do
        within('.question .subscriptions') do
          expect(page).to have_button('Unsubscribe')
        end
      end
    end

    describe 'Unauthorized user', js: true do
      scenario 'tries to subscribe to the question' do
        expect(page).not_to have_button('Subscribe')
      end
    end
end
