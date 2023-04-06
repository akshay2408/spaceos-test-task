# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'short_links', type: :request do
  path '/short_links' do
    post('Creates a short link') do
      tags 'Short Links'
      consumes 'application/json'
      parameter name: :short_link, in: :body, schema: {
        type: :object,
        properties: {
          url: { type: :string },
          custom_key: { type: :string },
          expires_in_days: { type: :integer }
        },
        required: %w[url]
      }

      response '201', 'short link created' do
        let(:short_link) { { url: 'www.google.com', custom_key: 'my-key', expires_in_days: 3 } }

        run_test!
      end

      response '422', 'invalid request' do
        let(:short_link) { { url: '' } }
        run_test!
      end
    end
  end

  path '/short_links/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show short link') do
      tags 'Get Short Link'

      response(200, 'Successful') do
        let(:id) { '123' }
        run_test!
      end

      response(404, 'Not Found') do
        let(:id) { '' }
        run_test!
      end
    end
  end
end
