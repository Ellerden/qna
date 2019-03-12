# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = current_user.answers.create(answer_params.merge(question_id: question.id))
  end

  def destroy
    return head :forbidden unless current_user.author_of?(answer)

    answer.destroy
  end

  def edit; end

  def update
    return head :forbidden unless current_user.author_of?(answer)

    answer.update(answer_params)
  end

  def set_best
    answer.rate_best if current_user.author_of?(answer.question)
  end

  private

  def question
    @question ||= params[:question_id] ? Question.with_attached_files.find(params[:question_id]) : nil
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  helper_method :answer, :question

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
