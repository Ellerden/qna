require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.find' do
    it 'searches each category' do
      %w(Question Answer Comment User).each do |resource|
        expect(resource.constantize).to receive(:search).with('test')
        Search.find('test', resource)
      end
    end

    it 'searches All' do
      expect(ThinkingSphinx).to receive(:search).with('test')
      Search.find('test', '')
    end
  end
end
