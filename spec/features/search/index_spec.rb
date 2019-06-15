require 'sphinx_helper'

feature 'User can search for question, comment, answer or user', %q{
  In order to find needed info faster
  As a user
  I'd like to be able to use search
}, sphinx: true do
  given!(:user) { create(:user, email: 'user@user.ru') }
  given!(:question) { create(:question, title: 'question1', body: 'my job is to ask', author: user) }
  given!(:answer) { create(:answer, body: 'my job is to answer', question: question, author: user) }
  given!(:comment) { create(:comment, body: 'my job is to comment', commentable: answer, author: user) }

  scenario 'User searches for everything', js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within '.search' do
        fill_in 'query', with: 'job'
        click_on 'Search'
      end

      expect(page).to have_content question.title
      expect(page).to have_content answer.body
      expect(page).to have_content comment.body
    end
  end

  scenario 'User searches for the question', js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within '.search' do
        fill_in 'query', with: 'job'
        select "Question", from: 'category'
        click_on 'Search'
      end

      expect(page).to have_content question.title
      expect(page).not_to have_content answer.body
      expect(page).not_to have_content comment.body
    end
  end

  scenario 'User searches for the answer', js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within '.search' do
        fill_in 'query', with: 'job'
        select "Answer", from: 'category'
        click_on 'Search'
      end

      expect(page).to have_content answer.body
      expect(page).not_to have_content question.title
      expect(page).not_to have_content comment.body
    end
  end

  scenario 'User searches for the comment', js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within '.search' do
        fill_in 'query', with: 'job'
        select "Comment", from: 'category'
        click_on 'Search'
      end

      expect(page).to have_content comment.body
      expect(page).not_to have_content answer.body
      expect(page).not_to have_content question.title
    end
  end

  scenario 'User searches for the user', js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within '.search' do
        fill_in 'query', with: 'user@user.ru'
        select "User", from: 'category'
        click_on 'Search'
      end

      expect(page).to have_content user.email
    end
  end
end
