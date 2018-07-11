class TobanhyosController < ApplicationController
  def index
    @tobanhyos = Tobanhyo.all.group_by(&:start_of_period).keys
  end

  def show
    @tobanhyo = Tobanhyo.where(start_of_period: params[:start_of_period]).group_by(&:fixed)
  end
end
