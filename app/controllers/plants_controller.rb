class PlantsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_special_user!

  def create
    @plant = current_user.plants.build
    uploaded_photo = plant_params[:photo]

    @plant.photo.attach(uploaded_photo) if uploaded_photo.present?

    if uploaded_photo.present?
      attributes = PlantIdentifierService.new(@plant, current_user, uploaded_photo.tempfile.path).identify
      @plant.assign_attributes(attributes)
    end

    if @plant.save
      redirect_to special_page_path, notice: "Ta plante a été ajoutée à ton jardin 🌱"
    else
      redirect_to special_page_path, alert: "Impossible d'ajouter la plante. Vérifie la photo et réessaie."
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
