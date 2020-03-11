Rails.application.routes.draw do
  get '/', to: 'home#health'

  namespace :api do
    post 'signup', to: 'users#signup'
  end
end
