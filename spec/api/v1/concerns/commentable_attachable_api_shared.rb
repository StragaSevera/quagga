require 'rails_helper'

shared_examples_for 'commentable and attachable api' do |request, root, additional_nodes = []|
  let(:access_token) { create(:doorkeeper_access_token) }

  before { get request, format: :json, access_token: access_token.token }

  it 'returns 200 status code' do
    expect(response).to be_success
  end

  %w(id body created_at updated_at).concat(additional_nodes).each do |attr|
    it "object contains #{attr}" do
      expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{root}/#{attr}")
    end
  end

  context 'attachments' do
    it 'returns list of attachments' do
      expect(response.body).to have_json_size(2).at_path("#{root}/attachments")
    end

    it 'returns id of attachment' do
      expect(response.body).to be_json_eql(attachment.id.to_json).at_path("#{root}/attachments/0/id")
    end

    # Очень некрасиво, но никакие манипуляции с @request.host и host! не помогли
    it 'returns url of attachment' do
      expect(response.body).to be_json_eql("http://localhost:3000#{attachment.file.url}".to_json).at_path("#{root}/attachments/0/url")
    end         
  end

  context 'comments' do
    it 'returns list of comments' do
      expect(response.body).to have_json_size(2).at_path("#{root}/comments")
    end

    %w(id user_id body created_at updated_at).each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("#{root}/comments/0/#{attr}")
      end
    end
  end  
end