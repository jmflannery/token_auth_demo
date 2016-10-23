class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def authenticate_token
    @user = authenticate_with_http_token do |key, options|
      token = Token.find_by key: key
      token.user if token
    end
    head 401 unless @user
  end
end
