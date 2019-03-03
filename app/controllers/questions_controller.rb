# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def show; end

  def new
    @question = current_user.questions.build
    #@question = Question.new
  end

  def edit; end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question was successfully created.'
    else
      render :new, notice: 'Something went wrong - question was not added. Try again.'
    end
  end

  def update
    return unless current_user && current_user.author_of?(question)

    if question.update(question_params)
      redirect_to question, notice: 'Your question was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    question.destroy if current_user.author_of?(question)
    redirect_to questions_path
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
