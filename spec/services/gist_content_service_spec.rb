require 'rails_helper'

RSpec.describe 'GistContentService' do
  let(:valid_gist) { GistContentService.new('99a9c41e41be4e325fb38024f829c4dc') }

  describe '#call' do
    it 'returns a gist content' do
      expect(valid_gist.call).to eq('MyGist')
    end
  end
end
