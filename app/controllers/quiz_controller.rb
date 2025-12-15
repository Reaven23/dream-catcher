class QuizController < ApplicationController
  skip_before_action :check_quiz_completion
  layout 'onboarding'

  def new
    @user = current_user
    # Rediriger si déjà complété
    redirect_to root_path if @user.onboarding_completed?
  end

  def create
    @user = current_user

    # Mettre à jour avec les paramètres (même si certains sont vides)
    @user.assign_attributes(quiz_params)

    # Toujours marquer comme complété, même si certains champs sont vides
    @user.onboarding_completed = true

    if @user.save
      redirect_to root_path, notice: 'Bienvenue dans DreamCatcher ! Vous pouvez maintenant enregistrer vos rêves.'
    else
      # Si erreur de validation (email, etc.), on marque quand même comme complété
      @user.onboarding_completed = true
      @user.save(validate: false)
      redirect_to root_path, notice: 'Bienvenue dans DreamCatcher ! Vous pouvez maintenant enregistrer vos rêves.'
    end
  end

  private

  def quiz_params
    params.require(:user).permit(
      # Infos personnelles
      :first_name, :age, :gender, :pays, :zodiac_sign,
      # Sommeil et rêves
      :rappel_reves, :reves_lucides, :heure_sommeil,
      # Contexte émotionnel
      :stress_niveau, :humeur_generale,
      # Contexte de vie
      :situation_pro, :relationship_status,
      # Rapport aux rêves
      :symbolisme, :vision_reves,
      # Peurs et émotions
      :peurs_principales, :emotions_recurrentes,
      # Préférences d'analyse
      :ton_prefere, :longueur_analyse, :style_prefere,
      # Arrays
      source_stress: [], changements_recents: []
    )
  end
end
