# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = current_user.answers.create(answer_params.merge(question_id: question.id))
    if @answer.save
      redirect_to question, notice: 'Your answer was successfully added.'
    else
      render 'questions/show'
    end
  end

  def destroy
    return head :forbidden unless current_user.author_of?(answer)

    if answer.destroy
      redirect_to answer.question, notice: 'Your answer was successfully deleted.'
    else
      render 'questions/show', notice: 'Something went wrong - answer was not deleted. Try again.'
    end
  end

  def edit; end

  def update
    return unless current_user.author_of?(answer)

    if answer.update(answer_params)
      redirect_to answer.question
    else
      render 'questions/show'
    end
  end

  private

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : nil
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :answer, :question

  def answer_params
    params.require(:answer).permit(:body)
  end
end
