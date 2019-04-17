class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_resource, only: [:create]

  def create
    @comment = @resource.comments.create(author: current_user, body: comment_params['body'])
  end

  def destroy
    @comment.destroy if current_user.author_of?(comment)
  end

  private

  def comment
    @comment ||= params[:id] ? Comment.find(params[:id]) : Comment.new
  end

  helper_method :comment

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_resource
    @resource_type = request.path.split('/').second.singularize
    klass = @resource_type.classify.constantize
    @resource = klass.find(params["#{@resource_type}_id"])
  end
end
