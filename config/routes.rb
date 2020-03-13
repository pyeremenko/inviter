Rails.application.routes.draw do
  get '/', to: 'home#health'

  post 'login', to: 'users#auth'
  post 'signup', to: 'users#signup'
  get 'info', to: 'users#info'

  get 'invite', to: 'invites#show'
  get 'invite/:code', to: 'invites#apply', as: :apply_invite
end
