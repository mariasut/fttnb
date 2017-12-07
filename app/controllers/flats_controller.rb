class FlatsController < ApplicationController
  skip_before_action :authenticate_registration!, only: [:home, :index, :show]

  before_action :set_flat, only: [:show, :edit, :update, :destroy]
  before_action :set_all_flats, only: [:home, :index]

  def home
  end

  def index
    @flats = Flat.all   #where.not(latitude: nil, longitude: nil)

    @markers = Gmaps4rails.build_markers(@flats) do |flat, marker|
      marker.lat flat.latitude
      marker.lng flat.longitude
      marker.infowindow render_to_string(partial: "/flats/map_box", locals: { flat: flat })
    end
  end

  def show
     @flat_coordinates = { lat: @flat.latitude, lng: @flat.longitude }
     @markers = Gmaps4rails.build_markers(@flat) do |flat, marker|
      marker.lat flat.latitude
      marker.lng flat.longitude
      marker.infowindow render_to_string(partial: "/flats/map_box", locals: { flat: flat })
    end
  end

  def new
    @flat = Flat.new
  end

  def create
    user = current_user
    @flat = Flat.new(params_flat)
    @flat.user = user
    if @flat.save
      redirect_to myprofile_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    @flat.update(params_flat)
    redirect_to myprofile_path
  end

  def destroy
    @flat.destroy
    redirect_to myprofile_path
  end

  private

  def set_all_flats
    @flats = Flat.all
  end

  def set_flat
    @flat = Flat.find(params[:id])
  end

  def params_flat
    params.require(:flat).permit(:name, :address, :nb_rooms, :pets_allowed, :wifi_available, :wifi_pwd, :description, :pick_up_services, photos: [])
  end
end
