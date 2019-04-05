require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/Ellerden/bd429c74fe2ff1c2d229ca66b5440653' }
  given(:gist_url2) { 'https://gist.github.com/Ellerden/3290db1fbfe5de6fa67b827b4dedd045' }

  describe 'Author of the question', js: true do
    background do
      sign_in(user)
      visit new_question_path
      fill_in 'Title', with: 'question title'
      fill_in 'Body', with: 'text text text'
    end

    scenario 'adds VALID several links when leaves a question' do
      within('#question-links') do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url
        click_on 'Add link'
        wait_for_ajax
      end

      within all(".nested-fields")[1] do
        fill_in 'Link name', with: 'My gist2'
        fill_in 'Url', with: gist_url2
      end

      click_on 'Ask'
      within '.question' do
        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_link 'My gist2', href: gist_url2
      end
    end

    scenario 'adds INVALID URL to a link when leaves a question' do
      within('#question-links') do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: 'not_a_link'
        click_on 'Add link'
      end

      click_on 'Ask'
      expect(page).to have_content 'Links url is an invalid URL'
    end
  end

  scenario 'Anauthorized user cannot add links and leave answer' do
    visit new_question_path
    expect(page).not_to have_link 'Add link'
  end
end
