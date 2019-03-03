require 'rails_helper'

feature 'User can see list of questions', %q{
  In order to choose what question I'm interested in
  Or want to leave the answer to
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5, author: user) }

  scenario 'User sees list of questions' do
    visit questions_path
    questions.each { |q| expect(page).to have_content(q.title) }
  end

  scenario 'Authenticated user sees list of questions' do
    sign_in(user)
    visit questions_path
    questions.each { |q| expect(page).to have_content(q.title) }
  end
end
