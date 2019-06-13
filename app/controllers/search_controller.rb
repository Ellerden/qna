# frozen_string_literal: true

class SearchController < ApplicationController
  skip_authorization_check # CHANGE THAT FOR GUEST ABILITIES

  def index
    @results = Search.find(params[:query], params[:category]) if params[:query].present?
  end
end
