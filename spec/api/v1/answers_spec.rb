require 'rails_helper'

RSpec.describe 'Answers API', type: :request do
  # Указание ID "наживую", возможно, вызовет баги. Но по-другому без извращения с блоками before 
  # в ссылку его не вставить...
  let!(:question) { create(:question, id: 1) }

  describe 'GET /' do
    it_behaves_like 'unauthorized api', '/api/v1/questions/1/answers'

    context 'authorized' do
      let(:access_token) { create(:doorkeeper_access_token) }
      let!(:answers) { create_list(:answer_multi, 2, question: question) }
      # Чтобы не было проблем с сортировкой, берем через скоуп
      let(:answer) { question.answers.first }

      before { get '/api/v1/questions/1/answers', format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path("answers")
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let!(:answer) { create(:answer, question: question, id: 1) }
    let!(:attachments) { create_list(:attachment, 2, attachable_id: answer.id, attachable_type: "Answer") }
    let!(:comments) { create_list(:comment, 2, commentable_id: answer.id, commentable_type: "Answer") }

    it_behaves_like 'unauthorized api', '/api/v1/questions/1/answers/1'

    context 'authorized' do
      it_behaves_like 'commentable and attachable api', '/api/v1/questions/1/answers/1', :answer
    end
  end
end 