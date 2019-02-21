class AnswersController < ApplicationController
  def new; end

  def edit; end

  def create
    @answer = question.answers.build(answer_params)
    if @answer.save
      redirect_to question
    else
      render :new
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to answer.question
    else
      render :edit
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
