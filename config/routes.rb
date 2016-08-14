require 'sidekiq/web'

Rails.application.routes.draw do
  get 'searchs/index', to: 'searchs#index', as: 'search'
  post 'searchs/results'

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    get '/users/auth/failure' => 'omniauth_callbacks#failure'
    post '/finish_registration' => 'omniauth_callbacks#finish_registration'
    get '/finish_registration' => 'questions#index'
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions do
        resources :answers
      end
    end
  end

  concern :votable do
    member do
      patch :upvote
      patch :downvote
      patch :unvote
    end
  end

  concern :subscribable do
    member do
      post :subscribe
      delete :unsubscribe
    end
  end

  concern :commentable do
    resources :comments, only: [:create, :destroy]
  end


  resources :questions, concerns: [:votable, :commentable, :subscribable], shallow: true do
    resources :answers, concerns: [:votable, :commentable], shallow: true do
      patch :set_best, on: :member
    end
  end

  resources :attachments, only: :destroy

  root 'questions#index'

end
