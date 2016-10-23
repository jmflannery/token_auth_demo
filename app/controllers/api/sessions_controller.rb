module Api
  class SessionsController < ApplicationController
    def create
      authenticate_with_http_basic do |email, password|
        @user = User.find_by email: email
        if @user && @user.valid_password?(password)
          @user.token.generate_key
          @user.token.save
          response.headers['Authorization'] = "Token #{@user.token.key}"
          render json: {}, status: 201
        else
          head :unauthorized
        end
      end
    end

    def destroy
    end
  end
end
