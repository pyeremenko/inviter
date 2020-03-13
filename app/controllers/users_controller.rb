# Provides actions related to users.
class UsersController < ApplicationController
  skip_before_action :authenticate_request, except: :info

  def signup
    user = User.create(params.permit(:email, :password, :name))
    unless user.persisted?
      return render json: {
        error: 'Failed to save the user.', details: user.errors.messages
      }, status: :bad_request
    end

    invite = Invite.where(code: params[:code]).first
    if invite.present?
      command = IncreaseCredits.call(invite, user)
      unless command.success?
        logger.error("failed to increase credits: user: #{user.email}")
      end
    end

    perform_auth_command
  end

  def auth
    perform_auth_command
  end

  def info
    render json: { message: 'Ok.', user: @current_user.to_h }
  end

  private

  def perform_auth_command
    command = AuthenticateUser.call(params[:email], params[:password])
    user = User.find_by_email(params[:email])

    if command.success?
      render json: { 
        auth_token: command.result,
        user: user.to_h
      }
    else
      render json: {
        error: 'Failed to authenticate the user.', details: command.errors
      }, status: :unauthorized
    end
  end
end
