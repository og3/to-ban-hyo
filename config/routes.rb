Rails.application.routes.draw do
  # 当番表関連処理
  get 'tobanhyos' => 'tobanhyos#index'
  get 'tobanhyos/show/:start_of_period' => 'tobanhyos#show'
  get 'tobanhyos/new/:start_of_period' => 'tobanhyos#new'
  post 'tobanhyos' => 'tobanhyos#create'
  # room関連処理
  resources :rooms, :only => [:edit, :update, :index, :show]
  # ログイン関連処理
  get     'login',   to: 'sessions#new'
  post    'login',   to: 'sessions#create'
  delete  'logout',  to: 'sessions#destroy'
end
