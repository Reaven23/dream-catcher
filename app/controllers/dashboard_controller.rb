class DashboardController < ApplicationController
  def show
    @user = current_user
    @dreams_count = current_user.dreams.count
    @analyses_count = current_user.global_analyses.count
  end

  def update_profile
    @user = current_user

    if params[:user][:password].present?
      if @user.update(profile_params)
        bypass_sign_in(@user)
        redirect_to dashboard_path, notice: 'Profil mis à jour avec succès.'
      else
        render :show, status: :unprocessable_entity
      end
    else
      if @user.update(profile_params_without_password)
        redirect_to dashboard_path, notice: 'Profil mis à jour avec succès.'
      else
        render :show, status: :unprocessable_entity
      end
    end
  end

  def update_quiz
    @user = current_user
    @dreams_count = current_user.dreams.count
    @analyses_count = current_user.global_analyses.count

    if @user.update(quiz_params)
      redirect_to dashboard_path, notice: 'Informations mises à jour avec succès.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy_account
    current_user.destroy
    redirect_to root_path, notice: 'Votre compte a été supprimé avec succès.'
  end

  private

  def profile_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def profile_params_without_password
    params.require(:user).permit(:email)
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
