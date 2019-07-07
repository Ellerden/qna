# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  after_action :publish_answer, only: [:create]

  load_and_authorize_resource

  def create
    @answer = current_user.answers.create(answer_params.merge(question_id: question.id))
  end

  def destroy
    answer.destroy if current_user.author_of?(answer)
  end

  def edit
  end

  def update
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
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def publish_answer
    pp @answer.errors.any?
    pp @answer
    pp @question
    return if @answer.errors.any?
    AnswersChannel.broadcast_to(
      question,
      ApplicationController.render(
          partial: 'answers/answer.json.jbuilder',
          locals: { answer: @answer }
        )
    )
  end
end
