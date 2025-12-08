class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :check_quiz_completion

  private

  def check_quiz_completion
    return if devise_controller?
    return if controller_name == 'quiz'

    if user_signed_in? && !current_user.quiz_completed?
      redirect_to new_quiz_path, notice: "Veuillez compléter le quiz initial pour continuer."
    end
  end
end
