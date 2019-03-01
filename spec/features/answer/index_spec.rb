require 'rails_helper'

feature 'User can see answers to the particular question', %q{
  In order to solve the problem
  Or get to know other answers before leaving my own
  User can read all the answers
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:answer) { create(:answer, question: question, author: user) }
  given(:answers) { create_list(:answers, 3) }


    scenario 'User can see all the answers on the same page as the question' do
    end
  end

end

