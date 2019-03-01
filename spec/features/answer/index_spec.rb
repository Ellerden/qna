require 'rails_helper'

feature 'User can see answers to the particular question', %q{
  In order to solve the problem
  Or get to know other answers before leaving my own
  User can read all the answers
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  scenario 'User can see all the answers on the same page as the question' do
    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    expect(page).to have_content(@answers)
  end
end
