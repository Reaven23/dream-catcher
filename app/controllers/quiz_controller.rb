class QuizController < ApplicationController
  skip_before_action :check_quiz_completion
  layout 'onboarding'

  def new
    @user = current_user
    redirect_to root_path if @user.onboarding_completed?

    @show_christmas_modal = should_show_christmas_modal?
  end

  def create
    @user = current_user

    @user.assign_attributes(quiz_params)

    @user.onboarding_completed = true

    if @user.save
      redirect_to root_path, notice: 'Bienvenue dans DreamCatcher ! Vous pouvez maintenant enregistrer vos rêves.'
    else
      @user.onboarding_completed = true
      @user.save(validate: false)
      redirect_to root_path, notice: 'Bienvenue dans DreamCatcher ! Vous pouvez maintenant enregistrer vos rêves.'
    end
  end

  private

  def should_show_christmas_modal?
    return false unless user_signed_in?
    return false unless special_user?
    return false if current_user.christmas_modal_shown_at.present?
    account_created_recently = current_user.created_at > 24.hours.ago
    account_created_recently
  end

  def special_user?
    current_user&.email == ENV['SPECIAL_USER_EMAIL']
  end

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
