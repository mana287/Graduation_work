Rails.application.routes.draw do
  get "articles/index"
  root "home#index"

  # 後で使うルーティング（今は動かなくてもOK）
  resources :articles do
    resources :comments, only: [:create, :destroy]
    resource  :like,     only: [:create, :destroy], controller: "article_likes"
  end
  resources :comments, only: [] do
    resource :like,     only: [:create, :destroy], controller: "comment_likes"
  end
  resources :tags, only: [:index, :show]
  resources :categories, only: [:index, :show]

  # ログイン・新規登録（今は仮ページ）
  get "/login",  to: "home#index"
  get "/signup", to: "home#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
