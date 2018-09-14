class ApplicationController < ActionController::Base
  # protect_from_forgeryはCSRF対策のためのメソッドでCSRF対策しない場合はこの行を削除するかコメントアウトすれば効かなくなる。
  protect_from_forgery with: :exception
  before_action :current_room
  # 全ページでログインしていないとログイン画面に飛ばす
  before_action :require_sign_in!
  # viewからこのメソッドを呼び出すため
  helper_method :signed_in?
  helper_method :admin?

  def current_room
    remember_token = Room.encrypt(cookies[:room_remember_token])
    @current_room ||= Room.find_by(remember_token: remember_token)
  end

  def sign_in(room)
    # トークンを生成
    remember_token = Room.new_remember_token
    # cokiesにトークンを入れる
    cookies.permanent[:room_remember_token] = remember_token
    # remember_tokenカラムにトークンを暗号化して入れる
    room.update!(remember_token: Room.encrypt(remember_token))
    # 部屋情報を入れる
    @current_room = room
  end

  def sign_out
    # cokiesとログイン中のユーザーを削除
    @current_room = nil
    cookies.delete(:room_remember_token)
  end

  def signed_in?
    @current_room.present?
  end

  # 微妙か？
  def not_admin?
    unless @current_room.admin?
      redirect_to room_path(@current_room)
    end
  end

  def admin?
    @current_room.admin?
  end

  private
    # サインインしてなかったらログインページへ
    def require_sign_in!
      redirect_to login_path unless signed_in?
    end

end
