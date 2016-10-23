require 'test_helper'

OUTER_APP = Rack::Builder.parse_file('config.ru').first

class SessionTest < ActiveSupport::TestCase

  include Rack::Test::Methods

  let(:app) { OUTER_APP }

  describe 'GET posts' do

    let(:user) { User.create(email: 'test@example.com', password: 'secret') }
    let(:token) { Token.create }
    let(:post1) { Post.create(title: 'My Post', content: 'Hello World') }
    let(:post2) { Post.create(title: 'Another Post', content: 'Ruby Rocks') }
    let(:posts) { [post1, post2] }

    setup do
      posts.size
      token.generate_key
      user.token = token #save
    end

    describe 'with a valid token' do
      setup do
        header 'Authorization', "Token #{token.key}"
      end

      it 'returns 200 OK' do
        get 'api/posts'
        assert_equal 200, last_response.status
      end

      it 'returns all posts' do
        get 'api/posts'
        posts = JSON.parse(last_response.body)
        assert_equal 2, posts.size
        assert_equal 'My Post', posts[0]['title']
        assert_equal 'Ruby Rocks', posts[1]['content']
      end
    end

    describe 'with an invalid token' do
      setup do
        header 'Authorization', "Token wrong"
      end

      it 'returns 401 Unathorized' do
        get 'api/posts'
        assert_equal 401, last_response.status
      end
    end

    describe 'with no token' do

      it 'returns 401 Unathorized' do
        get 'api/posts'
        assert_equal 401, last_response.status
      end
    end
  end
end
