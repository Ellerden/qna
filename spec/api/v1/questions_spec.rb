require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  let(:resource) { 'question' }

  let(:user) { create(:user) }
  let!(:questions) { create_list(:question, 2, author: user) }
  let!(:question) { questions.first }
  let(:question_response) { json['questions'].first }
  let!(:answers) { create_list(:answer, 3, question: question, author: user) }
  let!(:answer) { answers.first }
  let(:answer_response) { question_response['answers'].first }
  
  describe 'GET #index (/api/v1/questions/)' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'Authorized' do
      let(:access_token) { create(:access_token) }
      
      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }
      
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr| 
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains author' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr| 
            expect(answer_response[attr].to_json).to eq answer.send(attr).to_json
          end
        end
      end
    end
  end

  describe 'GET #show' do
    let!(:comments) { create_list(:comment, 3, commentable: question, author: user) }
    let!(:comment) { comments.first }
    let!(:link) { create(:link, linkable: question) }
    let(:file) { question.files.first }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'Authorized' do
      let(:access_token) { create(:access_token) }

      before do
        question.files.attach(io: Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers 
      end
      
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns body of the particular question' do
        questions.each do |q|
          expect(response.body).to include q.body
        end
      end

      describe 'answers' do
        it 'returns list of answers of the particular question' do
          expect(json['question']['answers'].size).to eq 3
        end

        it 'returns answers of the particular question' do
          answers.each do |answer| 
            %w[id body created_at updated_at].each do |attr|
              expect(json['question']['answers'].to_json).to include answer.send(attr).to_json
            end
          end
        end
      end

      it_behaves_like 'API Linkable'
      it_behaves_like 'API Attachable'
      it_behaves_like 'API Commentable'
    end
  end
end
