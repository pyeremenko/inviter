# Provides default actions that don't require authentication.
class HomeController < ApplicationController
  skip_before_action :authenticate_request

  def health
    render json: { message: 'Ok' }
  end
end
