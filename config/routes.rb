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
    post "dashboard/change_name", to: "dashboard#change_name", as: :change_name_dashboard_index
    post "dashboard/change_password", to: "dashboard#change_password", as: :change_password_dashboard_index

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update, :destroy]
  end

  resources :support_requests do
    collection do
      get :my_requests
    end

    member do
      post :claim
    end

    resources :messages, only: [:create]
  end

  resources :activities, only: [:index] do
    collection do
      get :admin_index
    end
  end
end


