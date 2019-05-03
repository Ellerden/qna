# frozen_string_literal: true

class FilesController < ActionController::Base
  before_action :authenticate_user!

  authorize_resource

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @file.purge if current_user.author_of?(@file.record)
  end
end
