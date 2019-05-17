class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  def index
    @answers = Answer.where(question_id: question.id)
    render json: @answers
  end

  def show
    @answer = Answer.find(params[:id])

    render json: @answer
  end

  def create
    @answer = current_resource_owner.answers.create(answer_params.merge(question_id: question.id))

    render json: @answer
  end

  private

  def question
    @question =  Question.find(params[:question_id])
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body)
  end
end
