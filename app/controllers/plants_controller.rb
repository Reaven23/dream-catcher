class PlantsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_special_user!

  def index
    @plants = current_user.plants.order(created_at: :desc)
    @plant = Plant.new
  end

  def create
    @plant = current_user.plants.build
    uploaded_photo = plant_params[:photo]

    @plant.photo.attach(uploaded_photo) if uploaded_photo.present?

    if uploaded_photo.present?
      attributes = PlantIdentifierService.new(@plant, current_user, uploaded_photo.tempfile.path).identify
      @plant.assign_attributes(attributes)
    end

    if @plant.save
      respond_to do |format|
        format.turbo_stream do
          @plant = Plant.new
          @plants = current_user.plants.order(created_at: :desc)
          render "special/plants_update"
        end
        format.html do
          redirect_to plants_path, notice: "Ta plante a été ajoutée à ton jardin 🌱"
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          @plants = current_user.plants.order(created_at: :desc)
          render "special/plants_update"
        end
        format.html do
          redirect_to plants_path, alert: "Impossible d'ajouter la plante. Vérifie la photo et réessaie."
        end
      end
    end
  end

  def destroy
    @plant = current_user.plants.find(params[:id])
    @plant.destroy
    respond_to do |format|
      format.turbo_stream do
        @plant = Plant.new
        @plants = current_user.plants.order(created_at: :desc)
        render "special/plants_update"
      end
      format.html do
        redirect_to plants_path, notice: "La plante a été supprimée de ton jardin 🌿"
      end
    end
  end

  private

  def plant_params
    params.require(:plant).permit(:photo)
  end

  def ensure_special_user!
    unless helpers.special_user?
      redirect_to root_path, alert: "Accès réservé."
    end
  end
end
