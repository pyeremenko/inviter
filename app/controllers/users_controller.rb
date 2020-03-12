# Provides actions related to users.
class UsersController < ApplicationController
  skip_before_action :authenticate_request

  def signup
    user = User.create(params.permit(:email, :password, :name))

    unless user.persisted?
      return render json: {
        error: 'Failed to save the user.', details: user.errors.messages
      }, status: :bad_request
    end

    perform_auth_command
  end

  def auth
    perform_auth_command
  end

  private

  def perform_auth_command
    command = AuthenticateUser.call(params[:email], params[:password])

    if command.success?
      render json: { auth_token: command.result }
    else
      render json: {
        error: 'Failed to authenticate the user.', details: command.errors
      }, status: :unauthorized
    end
  end
end
