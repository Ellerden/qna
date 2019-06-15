# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    # it 'calls find on categories' do
    #   %w(Question Answer Comment User).each do |resource|
    #     get :index, params: { query: 'test', category: resource }
    #     expect(Search).to receive(:find).with('test', resource)
    #   end
    # end

    it 'renders index view' do
      get :index, params: { query: 'test', category: nil }
      expect(response).to render_template :index
    end
  end
end
