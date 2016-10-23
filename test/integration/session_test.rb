require 'test_helper'

OUTER_APP = Rack::Builder.parse_file('config.ru').first

class SessionTest < ActiveSupport::TestCase

  include Rack::Test::Methods

  let(:app) { OUTER_APP }

  describe 'Sign In' do

    let(:user) { User.create(email: 'test@example.com', password: 'secret') }
    let(:token) { Token.create }

    setup do
      token.generate_key
      user.token = token #save
    end

    describe 'with valid credientials' do

      setup do
        creds = ["test@example.com:secret"].pack("m*")
        header 'Authorization', "Basic #{creds}"
      end

      it 'returns 201 Created' do
        post 'api/signin'
        assert_equal 201, last_response.status
      end

      it 'returns an Authorization Token in the response header' do
        post 'api/signin'
        token_header = last_response.headers['Authorization']
        assert_match /\AToken \S{64}\z/, token_header
      end
    end

    describe 'with invalid credientials' do

      setup do
        creds = ["test@example.com:wrong"].pack("m*")
        header 'Authorization', "Basic #{creds}"
      end

      it 'returns 401 Unathorized' do
        post 'api/signin'
        assert_equal 401, last_response.status
      end
    end
  end
end
