# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def show
    @answer = question.answers.build
    question.answers.each { |answer| answer.links.build }
  end

  def new
    @question = Question.new
    @question.links.new
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question was successfully created.'
    else
      render :new
    end
  end

  def destroy
    return head :forbidden unless current_user.author_of?(question)

    if question.destroy
      redirect_to questions_path, notice: 'Your question was successfully deleted.'
    else
      render :show, notice: 'Something went wrong - question was not deleted. Try again.'
    end
  end

  def edit
    question.links.new
  end

  def update
    return head :forbidden unless current_user.author_of?(question)

    if question.update(question_params)
      redirect_to question, notice: 'Your question was successfully edited'
    else
      render :edit
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def answer
    @answer = question.answers.build
  end

  helper_method :question, :answer

  def question_params
    params.require(:question).permit(:title, :body, 
                                     files: [], links_attributes: [:id, :name, :url, :_destroy])
  end
end
