class AnonymouspostsController < ApplicationController
require 'line/bot'

  def new
    # どこのグループに投稿するかのパラメータをとる
    @send_to = params[:send_to]
    @group = params[:send_to]
    @group_name = if params[:send_to] == "couri024"
                    "couri024"
                  elsif params[:send_to] == "soujig"
                    "couri024掃除当番G"
                  elsif params[:send_to] == "test"
                    "だいそんクンテスト用"
                  else
                    redirect_to root_path, alert: "line_group_idが不正です"
                  end
  end

  def send_line
    # 空投稿を防ぐバリデーション
    if params[:message].empty?
      redirect_to :back, alert: "内容を入力してください"
    else
      # メッセージ作成
      message = {
        type: 'text',
        text: params[:message]
      }
      # line_idが不正だったらリダイレクト
      line_group_id = if params[:group] == "couri024"
                        "LINE_COURI024_GROUP"
                      elsif params[:group] == "soujig"
                        "LINE_SOUJI_GROUP"
                      else
                        "LINE_TEST_GROUP"
                      end
      client = Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_ACCESS_TOKEN"]
      }
      response = client.push_message(ENV[line_group_id], message)
      p response
      redirect_to root_path, notice: "正常に投稿されました"
    end
  end
end
