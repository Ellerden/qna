# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :find_subscription, only: %i[show update]
  after_action :publish_question, only: [:create]

  load_and_authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = question.answers.build
    gon.question_id = question.id
  end

  def new
    @question = Question.new
    @question.links.new
    @question.award = Award.new
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
                                     files: [], 
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     award_attributes: [:name, :image])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render_with_signed_in_user(
        current_user,
        partial: 'questions/title',
        locals: { question: @question },
        )
    )
  end

  def find_subscription
    @subscription = question.subscriptions.find_by(author_id: current_user.id) if current_user 
  end
end
