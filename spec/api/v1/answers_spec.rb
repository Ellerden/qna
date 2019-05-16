require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }
  let(:resource) { 'answer' }

  let(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answers) { create_list(:answer, 3, question: question, author: user) }
  let!(:answer) { answers.first }
  let!(:comments) { create_list(:comment, 3, commentable: answer, author: user) }
  let!(:comment) { comments.first }
  let(:link) { create(:link, linkable: answer) }

  describe 'GET #show' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context 'Authorized' do
      let(:access_token) { create(:access_token) }
    
      before do
        answers.first.files.attach(io: Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers 
      end
      
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns public fields of the particular answer' do
        %w[id body created_at updated_at].each do |attr| 
          expect(json['answer'][attr].to_json).to eq answer.send(attr).to_json
        end
      end

      it_behaves_like 'API Linkable'

      it_behaves_like 'API Attachable' do

      end

      it_behaves_like 'API Commentable'
    end
  end
end
