shared_examples_for "API Commentable" do
  context 'has comments' do
    # because of order DESC - files.first is last in json
    let!(:json_comment) { json["#{resource}"]['comments'].last }

    it 'returns list of comments' do
      expect(json["#{resource}"]['comments'].size).to eq 3
    end

    it 'contains all public fields for comments' do
        %w[id body created_at updated_at].each do |attr|
          expect(json_comment[attr].to_json).to eq comment.send(attr).to_json
        end
    end
  end
end
