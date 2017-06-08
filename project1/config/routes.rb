Rails.application.routes.draw do
  begin
    ActiveAdmin.routes(self)
  rescue
    puts "ActiveAdmin: #{$!.class}: #{$!}"
  end
  devise_for :users, ActiveAdmin::Devise.config

  get 'l/:id', to: 'shortener/shortened_urls#show'

  get 'mail_tracker/:auth_token', to: "application#mail_tracker", as: :mail_tracker

  root to: 'application#index'

  mount ExceptionLogger::Engine => "/exception_logger"

  get '/pagelayouts/:id', to: "pages#show"
  get '/pages/:id', to: "pages#show", skip_layout: true
  post '/pages/:id', to: "pages#show", skip_layout: true
  get '/express_checkout_callback', to: "pages#express_checkout_callback"
  get '/connect_callback', to: "pages#connect_callback"
  get '/connect_return_url', to: "v1/paypal#connect_return_url"
  get '/connect_cancel_url', to: "v1/paypal#connect_cancel_url"
  get '/setup_payment_succeed', to: "pages#setup_payment_succeed"
  get '/delayed_job' => DelayedJobWeb, anchor: false
  post '/delayed_job' => DelayedJobWeb, anchor: false

  namespace :proj1, defaults: {format: :json} do
    resources :videos do
      get :banner, on: :collection, action: :banner
      get :settings_videos, on: :collection, action: :settings_videos
      get :sample_videos, on: :collection, action: :sample_videos
    end
    resources :interviews, only: [:create]
    resources :banners
    resources :topics do
      member do
        get :sub_topics
      end
    end
  end

  namespace :users do
    get 'confirmation/:token', action: 'confirmation', as: 'confirmation'
  end

  unless Rails.env.production?
    get 'rails/mailers', to: 'rails/mailers#index'
    get 'rails/mailers/*path', to: 'rails/mailers#preview'
  end

  get 'change-password' => 'application#index', as: 'change-password'
  get 'reactivate', to: 'application#index', as: :reactivate
  get '*path' => 'application#index'
end
