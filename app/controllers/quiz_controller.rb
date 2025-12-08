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

    if @user.update(quiz_params)
      @user.update(onboarding_completed: true)
      redirect_to root_path, notice: 'Bienvenue dans DreamCatcher ! Vous pouvez maintenant enregistrer vos rêves.'
    else
      render :new, status: :unprocessable_entity
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
