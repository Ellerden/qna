require 'rails_helper'

feature 'User can see particular question', %q{
  To get detailed information about the question
  Read all the answers
  Or leave my own answer
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'User reads particular question and answers to it' do
    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    expect(page).to have_content(answer.body)
  end
end
