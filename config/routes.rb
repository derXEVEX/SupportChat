Rails.application.routes.draw do
  root "sessions#new"

  get "register", to: "users#new"
  post "users", to: "users#create"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "dashboard", to: "dashboard#index"

  get '/confirm_email', to: 'users#confirm_email', as: :confirmation

    post "dashboard/change_email", to: "dashboard#change_email", as: :change_email_dashboard_index


end
