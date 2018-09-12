class SessionsController < ApplicationController
  before_action :require_sign_in!, only: [:destroy]
  before_action :set_room, only: [:create]

  def new
    # ログインしていたらログインページにはいけず、個人ページに飛ぶようにする
    if signed_in?
      redirect_to room_path(@current_room)
    end
  end

  def create
    if @room.authenticate(session_params[:password])
      sign_in(@room)
      redirect_to room_path(@current_room)
    else
      flash.now[:danger] = t('.flash.invalid_password')
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to login_path
  end

  private

    def set_room
      @room = Room.find_by!(login_id: session_params[:login_id])
    rescue
      flash.now[:danger] = t('.flash.invalid_login_id')
      render action: 'new'
    end

    # 許可するパラメータ
    def session_params
      params.require(:session).permit(:login_id, :password)
    end

end
