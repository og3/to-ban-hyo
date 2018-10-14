class RolesController < ApplicationController
  before_action :set_role, only: [:update, :edit, :destroy]
  # 一覧と編集は管理者権限のみ
  before_action :not_admin?, only: [:new, :create, :update, :edit, :index]

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(role_params)
    if @role.save
      redirect_to roles_path, notice: "作成されました"
    else
      render 'new'
    end
  end

  def index
    # house_idが入るまではこれで対応
    @roles = Role.all
  end

  def edit
  end

  def update
    if @role.update(role_params)
      redirect_to roles_path, notice: "更新されました"
    else
      render 'edit'
    end
  end

  def destroy
    @role.destroy
    redirect_to roles_path, notice: "削除されました"
  end

  private

    def role_params
      params.require(:role).permit(:name, :memo)
    end

    def set_role
      @role = Role.find(params[:id])
    end
end
