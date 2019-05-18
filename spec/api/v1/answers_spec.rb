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
        answer.files.attach(io: Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
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
        let(:file) { answer.files.first }
      end

      it_behaves_like 'API Commentable'
    end
  end

  describe 'POST #create' do
    let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    context 'Authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }


      context "with valid attributes" do
        before do
          post "/api/v1/questions/#{question.id}/answers", params: { question_id: question, answer: attributes_for(:answer), access_token: access_token.token }
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'saves a new answer in a database' do
          expect { post "/api/v1/questions/#{question.id}/answers", params: { question_id: question, answer: attributes_for(:answer), access_token: access_token.token } }.to change(Answer, :count).by(1)
        end
      end

      context "with invalid attributes" do
        before do
          post "/api/v1/questions/#{question.id}/answers", params: { question_id: question, answer: attributes_for(:answer, :invalid), access_token: access_token.token }
        end

        it 'returns Unprocessable entity status' do
          expect(response.status).to be 422
        end

        it 'returns list of errors' do
          expect(json['errors']).not_to be_empty
        end
        
        it 'does not save a new answer in a database' do
          expect { post "/api/v1/questions/#{question.id}/answers", params: { question_id: question, answer: attributes_for(:answer, :invalid), access_token: access_token.token } }.not_to change(Answer, :count)
        end
      end
    end
  end


end
