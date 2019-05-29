require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/Ellerden/bd429c74fe2ff1c2d229ca66b5440653' }
  given(:gist_url2) { 'https://gist.github.com/Ellerden/3290db1fbfe5de6fa67b827b4dedd045' }

  describe 'Author of the answer', js: true do
    background do
      sign_in(user)
      wait_for_ajax
      visit question_path(question)
      fill_in 'Body', with: 'text text text'
    end

    scenario 'adds VALID several links when leaves an answer' do
      within('#answer-links') do
        click_on 'Add link'
        wait_for_ajax
        fill_in 'Link name', with: 'Gist1'
        fill_in 'Url', with: gist_url
        click_on 'Add link'
        wait_for_ajax
      end

      within all(".nested-fields")[1] do
        fill_in 'Link name', with: 'Gist2'
        fill_in 'Url', with: gist_url2
      end

      click_on 'Create Answer'
      wait_for_ajax
      within '.answers' do
        expect(page).to have_link 'Gist1', href: gist_url
        expect(page).to have_link 'Gist2', href: gist_url2
      end
    end

    scenario 'adds INVALID URL to a link when leaves an answer' do
      within('#answer-links') do
        click_on 'Add link'
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: 'not_a_link'
      end

      click_on 'Create Answer'
      expect(page).to have_content 'Links url is an invalid URL'
    end
  end

  scenario 'Anauthorized user cannot add links and leave answer' do
    visit question_path(question)
    expect(page).not_to have_link 'Add link'
  end
end
