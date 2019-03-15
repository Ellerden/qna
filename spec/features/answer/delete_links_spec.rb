require 'rails_helper'

feature 'User can delete links from answer', %q{
  As an author if I feel like links are no longer necessary
  I'd like to be able to delete any link
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:answer) { create(:answer, question: question, author: user) }
  given!(:link) { create :link, linkable: answer, name: 'google', url: 'http://google.com' }

  context 'Author of the answer', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      within(".answers") { click_on 'Edit' }
    end

    scenario 'deletes a link from his/her answer' do
      answer_links = find('.answers').first('#answer-links')
      within(answer_links) { click_on 'Delete link' }

      within('.answers') do
        click_on 'Save'
        expect(page).not_to have_link(link.name)
      end
    end
  end

  context 'NOT author of the answer' do
    given(:other_user) { create(:user) }

    background do
      sign_in(other_user)
      visit question_path(question)
    end

    scenario 'tries to delete someone elses answer' do
      within('.answers') { expect(page).not_to have_link 'Delete link' }
    end
  end
end
