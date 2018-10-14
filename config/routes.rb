Rails.application.routes.draw do
  root 'rooms#show'
  # 当番表関連
  get 'tobanhyos' => 'tobanhyos#index'
  get 'tobanhyos/show/:start_of_period' => 'tobanhyos#show'
  get 'tobanhyos/new/:start_of_period' => 'tobanhyos#new'
  post 'tobanhyos' => 'tobanhyos#create'
  # 部屋・役割関連
  resources :rooms, :only => [:new, :create, :edit, :update, :index, :show, :destroy]
  resources :roles, :only => [:new, :create, :edit, :update, :index, :show, :destroy]
  # ログイン関連
  get     'login',   to: 'sessions#new'
  post    'login',   to: 'sessions#create'
  delete  'logout',  to: 'sessions#destroy'
  # 匿名投稿関連
  get 'anonymousposts', to: 'anonymousposts#new'
  get 'anonymousposts/post', to: 'anonymousposts#send_line'
end
