require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:url) { 'https://gist.github.com/Ellerden/99a9c41e41be4e325fb38024f829c4dc' }
  let!(:gist) { Link.new(name: 'gist', url: url, linkable: question) }
  let!(:not_a_gist) { Link.new(name: 'gist', url: 'https://google.com', linkable: question) }

  describe '#gist?' do
    it 'justifies that link contents gist' do
      expect(gist).to be_gist
    end
  end

  describe '#gist_content' do
    it 'justifies it is a gist' do
      expect(gist.gist_content).to eq 'MyGist'
    end

    it 'indicates it is not a gist' do
      expect(not_a_gist.gist_content).to eq nil
    end
  end
end
