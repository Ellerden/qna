require 'rails_helper'

feature 'User can delete links from answer', %q{
  As an author if I feel like links are no longer necessary
  I'd like to be able to delete any link
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:link) { create :link, linkable: question, name: 'google', url: 'http://google.com' }

  context 'Author of the answer', js: true do
    background do
      sign_in(user)
      visit edit_question_path(question)
    end

    scenario 'deletes a link from his/her question' do
      question_links = find('#question-links').first('.nested-fields')
      within(question_links) { click_on 'Delete link' }

      click_on 'Ask'
      expect(page).not_to have_link(link.name)
    end
  end

  context 'NOT author of the answer' do
    given(:other_user) { create(:user) }

    background do
      sign_in(other_user)
      visit question_path(question)
    end

    scenario 'tries to delete someone elses answer' do
      within('.question') { expect(page).not_to have_link 'Delete link' }
    end
  end
end
