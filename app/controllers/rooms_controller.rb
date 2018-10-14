class RoomsController < ApplicationController
  before_action :set_room, only: [:update, :edit, :destroy]
  # 一覧と編集は管理者権限のみ
  before_action :not_admin?, only: [:new, :create, :update, :edit, :index]

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to rooms_path, notice: "作成されました"
    else
      render 'new'
    end
  end

  def index
    # house_idが入るまではこれで対応
    @rooms = Room.all
  end

  def edit
  end

  def update
    if @room.update(room_params)
      redirect_to rooms_path, notice: "更新されました"
    else
      render 'edit'
    end
  end

  def show
    # ログイン中のユーザーの情報を表示しているので他のユーザーが入ってくることはない
    @current_room
    # fixme
    # 最新の当番を表示。ただし、lastとしているので、新規で当番表を追加した場合にはLINE投稿前の当番表も検索対象になる。カラム追加後に修正
    @toban = Tobanhyo.where(room_id: @current_room.id).last
  end

  def destroy
    @room.destroy
    redirect_to rooms_path, notice: "削除されました"
  end

  private

    def room_params
      params.require(:room).permit(:name, :login_id, :admin, :password, :password_confirmation)
    end

    def set_room
      @room = Room.find(params[:id])
    end
end
