class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @subscription = current_user.subscriptions.create(question: question)
    flash.now[:notice] = "Subscription created! Now you'll receive all answer updates"
  end

  def destroy
    @question = subscription.question
    subscription.destroy!
    flash.now[:notice] = "Subscription deleted! You won't receive any answer updates"
  end

  private

  def question
    @question ||= params[:question_id] ? Question.with_attached_files.find(params[:question_id]) : nil
  end

  def subscription
    @subscription ||= Subscription.find(params[:id])
  end

  helper_method :question, :subscription
end
