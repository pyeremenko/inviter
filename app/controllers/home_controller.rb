class HomeController < ApplicationController
  def health
    render json: {message: 'Ok'}
  end
end
