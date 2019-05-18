shared_examples_for "API Linkable" do
  context 'Has links' do
    it 'returns links of the particular resource' do
        expect(response.body).to include link.name
    end
  end
end
