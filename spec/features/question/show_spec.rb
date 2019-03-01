require 'rails_helper'

feature 'User can see particular question', %q{
  To get detailed information about the question
  Read all the answers
  Or leave my own answer 
} do

  describe 'Authenticated user' do
    scenario 'leaves an answer to the particular question' do
    end
  end

  scenario 'User reads particular question and answers to it' do
   # visit question_path(question)
  end
end
