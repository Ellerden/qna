# frozen_string_literal: true

class AnswersController < ApplicationController
  def new
    @answer = question.answers.new
  end

  def edit; end

  def create
    @answer = question.answers.build(answer_params)
    @answer.author = current_user
    if @answer.save
      redirect_to question, notice: 'Your answer was successfully added.'
    else
      redirect_to question, alert: 'Something went wrong - answer was not added. Try again.'
    end
  end

  def update
    return unless current_user.author_of?(answer)

    if answer.update(answer_params)
      redirect_to answer.question
    else
      render :edit
    end
  end

  def destroy
    question_to_redirect = answer.question
    answer.destroy if current_user.author_of?(answer)
    redirect_to question_to_redirect
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
