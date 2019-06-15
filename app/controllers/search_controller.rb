# frozen_string_literal: true

class SearchController < ApplicationController
  authorize_resource

  def index
    @results = Search.find(params[:query], params[:category]) if params[:query].present?
  end
end
