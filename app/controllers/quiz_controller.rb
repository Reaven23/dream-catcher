class QuizController < ApplicationController
  skip_before_action :check_quiz_completion

  def new
    @user = current_user
  end

  def create
    @user = current_user
    @user.validating_quiz = true

    if @user.update(quiz_params)
      redirect_to root_path, notice: 'Merci d\'avoir complété le quiz. Vous pouvez maintenant enregistrer vos rêves.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def quiz_params
    params.require(:user).permit(:first_name, :zodiac_sign, :age, :relationship_status, :gender)
  end
end
