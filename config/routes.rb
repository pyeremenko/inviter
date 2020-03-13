Rails.application.routes.draw do
  get '/', to: 'home#health'

  post 'login', to: 'users#auth'
  post 'signup', to: 'users#signup'
  get 'info', to: 'users#info'

  resource :invite, only: :show
end
