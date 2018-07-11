Rails.application.routes.draw do
  root 'tobanhyos#index'
  get 'tobanhyos/show/:start_of_period' => 'tobanhyos#show'
end
