require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of an question
  I'd like to be able to edit my question
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    context 'as an author' do
      background do
        sign_in user
        visit question_path(question)
        click_on 'Edit'
      end

      scenario 'edits his/her question' do
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Ask'

        expect(current_path).to eq question_path(question)
        expect(page).to have_content 'Your question was successfully edited'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
      end

      scenario 'edits his/her question with errors' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Ask'

        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end

      scenario 'adds missing files to the question' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Ask'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    context 'as not an author' do
      background do
        sign_in user2
        visit question_path(question)
      end

      scenario 'tries to edit someone elses question' do
        expect(page).to have_content(question.title)
        expect(page).to have_content(question.body)

        expect(page).not_to have_link 'Edit'
      end
    end
  end
end
