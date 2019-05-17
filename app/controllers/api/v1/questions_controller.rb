class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource

  def index
    @questions = Question.all

    render json: @questions, each_serializer: QuestionCollectionSerializer
  end

  def show
    @question = Question.find(params[:id])
    render json: @question
  end

  def create
    @question = current_resource_owner.questions.create(question_params)
    render json: @question
  end

  def update
    current_resource_owner.questions.update(question_params)
  end

  def destroy
    question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
