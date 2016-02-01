require 'rails_helper'

shared_examples_for 'commentable and attachable api' do |request, object, additional_nodes = []|
  let(:access_token) { create(:doorkeeper_access_token) }
  # Чтобы не было проблем с сортировкой, берем через скоуп
  let!(:attachment) { send(object).attachments.first }
  let!(:comment) { send(object).comments.first }

  before { get request, format: :json, access_token: access_token.token }

  it 'returns 200 status code' do
    expect(response).to be_success
  end

  %w(id body created_at updated_at).concat(additional_nodes).each do |attr|
    it "object contains #{attr}" do
      expect(response.body).to be_json_eql(send(object).send(attr.to_sym).to_json).at_path("#{object.to_s}_show/#{attr}")
    end
  end

  context 'attachments' do
    it 'returns list of attachments' do
      expect(response.body).to have_json_size(2).at_path("#{object.to_s}_show/attachments")
    end

    it 'returns id of attachment' do
      expect(response.body).to be_json_eql(attachment.id.to_json).at_path("#{object.to_s}_show/attachments/0/id")
    end

    # Очень некрасиво, но никакие манипуляции с @request.host и host! не помогли
    it 'returns url of attachment' do
      expect(response.body).to be_json_eql("http://localhost:3000#{attachment.file.url}".to_json).at_path("#{object.to_s}_show/attachments/0/url")
    end         
  end

  context 'comments' do
    it 'returns list of comments' do
      expect(response.body).to have_json_size(2).at_path("#{object.to_s}_show/comments")
    end

    %w(id user_id body created_at updated_at).each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("#{object.to_s}_show/comments/0/#{attr}")
      end
    end
  end  
end