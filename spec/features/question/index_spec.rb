require 'rails_helper'

feature 'User can see list of questions', %q{
  In order to choose what question I'm interested in
  Or want to leave the answer to
} do

  scenario 'User sees list of questions' do
    visit questions_path
    expect(page).to have_content @questions
  end

# думаю что выбор вопроса должен быть все-таки здесь
  scenario 'chooses particular question' do
    visit questions_path
    click_on question_path
  end
end
