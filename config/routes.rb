Rails.application.routes.draw do
  # linedevで設定しているwebhookURLと同じにすると、グループユーザーのコメント等に反応してしまうため、URLを変更した
  post '/send_tobanhyo' => 'tobanhyos#send_msg'
  post '/send_remind_msg' => 'tobanhyos#send_remind_msg'
end
