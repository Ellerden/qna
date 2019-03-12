require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }

    context 'Author of the file' do   
      before { login(user) }

      it 'deletes the file' do
        question.files.attach(io: Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')

        expect { delete :destroy, params: { id: question.files.last }, format: :js }.to change(question.files, :count).by(-1)
      end
    end

    context 'NOT an author of the file' do
      let(:other_user) { create(:user) }
      let!(:foreign_question) { create(:question, author: other_user) }

      before { login(user) }

      it 'tries to delete someone elses file' do
        foreign_question.files.attach(io: Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        expect { delete :destroy, params: { id: foreign_question.files.last }, format: :js }.not_to change(foreign_question.files, :count)
      end
    end
  end
end
