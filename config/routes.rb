Rails.application.routes.draw do
  # linedevで設定しているwebhookURLと同じにすると、グループユーザーのコメント等に反応してしまうため、URLを変更した
  post '/webhook2' => 'tobanhyos#send_line_msg'
end
