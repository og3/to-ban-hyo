Rails.application.routes.draw do
  root 'tobanhyos#index'
  get 'tobanhyos/show/:start_of_period' => 'tobanhyos#show'
  get 'tobanhyos/new/:start_of_period' => 'tobanhyos#new'
  post 'tobanhyos' => 'tobanhyos#create'
end
