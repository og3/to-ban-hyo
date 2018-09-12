class TobanhyosController < ApplicationController

  before_action :not_admin?

  def index
    @tobanhyos = Tobanhyo.all.group_by(&:start_of_period).keys
  end

  def show
    @tobanhyo = Tobanhyo.where(start_of_period: params[:start_of_period]).group_by(&:fixed)
  end

  def new
    @new_tobanhyo = Tobanhyo.new
    # 先週の当番表をコピーする
    @tobanhyo = Tobanhyo.where(start_of_period: params[:start_of_period]).map(&:dup)
    # プルダウンで選択できるように、部屋・役割の一覧をハッシュで作成する
    @rooms = {}
    @roles = {}
    @tobanhyo.each do |hyo|
      @rooms[hyo.room.name] = hyo.room.id
      @roles[hyo.role.name] = hyo.role.id
    end
    # 役割が固定かどうかでグルーピングする
    @tobanhyos = @tobanhyo.group_by(&:fixed)
  end

  def create
    tobans_params.map do |item_param|
      new_tobanhyo = Tobanhyo.new(item_param)
      new_tobanhyo.save
    end
    # 暫定対応
    redirect_to(root_path)
  end

  private
    def tobans_params
      # 第二引数の[:tobans]をつけないと[tobans,[各種paramsの値]]となってmapで回せなくなってしまう
      params.permit(tobans: [:room_id, :role_id, :fixed, :start_of_period])[:tobans]
    end
end
