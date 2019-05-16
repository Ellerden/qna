shared_examples_for "API Attachable" do
  context 'has files' do
    # because of order DESC - files.first is last in json
    let(:json_file) { json["#{resource}"]['files'].last }

    it 'returns list of files' do
      expect(json["#{resource}"]['files'].size).to eq 1
    end

    it 'contains filename' do
      expect(json_file['filename']).to eq file.blob.filename.to_json
    end

    it 'contains file url' do
      expect(json_file['url']).to eq rails_blob_path(file)
    end
  end
end
