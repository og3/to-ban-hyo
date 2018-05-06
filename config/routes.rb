Rails.application.routes.draw do
  post '/webhook' => 'tobanhyos#send_line_msg'
end
