# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShortLinksController, type: :request do
  describe 'POST #create' do
    context 'with valid parameters' do
      let(:short_link_params) { { short_link: { url: 'https://www.example.com', expires_in_days: 7, custom_key: 'example' } } }

      it 'creates a new short link' do
        post '/short_links', params: short_link_params
        expect(response).to have_http_status(:created)
        expect(json_response['message']).to eq('success')
        expect(json_response['data']['short_url']).to be_present
        expect(json_response['data']['expires_on']).to be_present
      end
    end

    context 'with invalid parameters' do
      let(:short_link_params) { { short_link: { url: '', expires_in_days: 7, custom_key: 'example' } } }

      it 'returns an error message' do
        post '/short_links', params: short_link_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['message']).to eq('Validation failed: Url can\'t be blank')
      end
    end
  end

  describe 'GET #show' do
    let(:short_link) { create(:short_link) }

    it 'redirects to the original URL and increments the click count' do
      expect do
        get "/short_links/#{short_link.uuid}"
      end.to change { short_link.reload.click_count }.by(1)

      expect(json_response['data']['redirect_to']).to eq(short_link.url)
    end

    context 'with an invalid short URL identifier' do
      let(:expected_message) { "Couldn't find ShortLink with [WHERE (uuid = 'invalid' OR custom_key = 'invalid')]" }
      it 'returns a not found error' do
        get '/short_links/invalid'
        expect(response).to have_http_status(:not_found)
        expect(json_response['message']).to eq(expected_message)
      end
    end
  end
end
