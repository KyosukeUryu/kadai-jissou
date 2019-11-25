class PropertiesController < ApplicationController
  before_action :set_property, only: %i[show edit update destroy]

  def index
    @properties = Property.all
  end

  def new
    @property = Property.new
    2.times do
      @property.nearest_stations.build
    end
  end

  def create
    @property = Property.new(property_params)
    if @property.save
      redirect_to properties_path, notice: '登録完了しました'
    else
      render :new
    end
  end

  def show
    @nearest_station1 = @property.nearest_stations.first
    @nearest_station2 = @property.nearest_stations.last
  end

  def edit
    @new_station = @property.nearest_stations.last
    if @new_station.name.present? && @new_station.route.present? && @new_station.on_foot.present?
      @property.nearest_stations.build
    end
  end

  def update
    if @property.update(update_property_params)
      redirect_to properties_path, notice: '更新しました'
    else
      render :edit
    end
  end

  def destroy
    @property.destroy
    redirect_to properties_path, notice: '削除しました'
  end

  private

  def property_params
    params.require(:property).permit(:name, :rent, :address, :age, :remarks, nearest_stations_attributes:[:route, :name, :on_foot])
  end

  def update_property_params
    params.require(:property).permit(:name, :rent, :address, :age, :remarks, nearest_stations_attributes:[:id, :route, :name, :on_foot])
  end

  def set_property
    @property = Property.find(params[:id])
  end

end
