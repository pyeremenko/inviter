require 'rails_helper'

RSpec.describe 'home', type: :request do
  describe 'GET / (health check)' do
    before { get '/' }

    let(:content_type) { response.content_type }

    it 'returns a success response' do
      expect(response).to be_successful
      expect(content_type).to include 'application/json'
      expect(json_body).to include 'message' => 'Ok'
    end
  end
end
