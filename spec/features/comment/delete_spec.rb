require 'rails_helper'

feature 'User can delete his/her comment', %q{
  As an author of the comment
  I want to be able to delete it
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:comment) { create(:comment, author: user, commentable: question) }

  describe 'Author of the comment', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to delete his/her own comment' do
      within '.question .comments' do
        expect(page).to have_content(comment.body)
        click_on 'Delete'
      end

      expect(page).to have_no_content(comment.body)
    end
  end

  describe 'NOT an author of the comment', js: true do
    background do
      sign_in(user2)
      visit question_path(question)
    end

    scenario 'tries to delete someone elses comment' do
      within '.question' do
        expect(page).to have_content(comment.body)
        expect(page).to have_no_link 'Delete'
      end
    end
  end

  scenario 'Unauthorized user tries to delete someones comment' do
    visit question_path(question)

    within '.question' do
      expect(page).to have_content(comment.body)
      expect(page).to have_no_link 'Delete'
    end
  end
end
