class DreamsController < ApplicationController
  before_action :set_dream, only: [:show, :destroy]

  def index
    @dreams = current_user.dreams.recent.includes(:analysis)
  end

  def show
    @analysis = @dream.analysis
  end

  def new
    @dream = Dream.new
    @dream.date = Date.today
  end

  def create
    @dream = current_user.dreams.build(dream_params)

    if @dream.save
      # Générer l'analyse avec l'IA (retourne titre + analyse)
      interpreter = DreamInterpreterService.new(@dream, current_user)
      result = interpreter.interpret

      # Mettre à jour le titre avec celui généré par l'IA
      if result[:title].present?
        @dream.update(title: result[:title])
      end

      # Créer l'analyse
      @dream.create_analysis(interpretation: result[:analysis])

      redirect_to @dream, notice: 'Votre rêve a été analysé avec succès.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @dream.destroy
    redirect_to dreams_path, notice: 'Le rêve a été supprimé avec succès.'
  end

  private

  def set_dream
    @dream = current_user.dreams.find(params[:id])
  end

  def dream_params
    params.require(:dream).permit(:content, :date)
  end
end
