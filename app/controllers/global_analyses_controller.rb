class GlobalAnalysesController < ApplicationController
  before_action :set_global_analysis, only: [:show, :destroy]

  def index
    @global_analyses = current_user.global_analyses.recent
    @dreams = current_user.dreams.recent.includes(:analysis)
    @can_generate = @dreams.count >= 1
  end

  def show
  end

  def create
    @dreams = current_user.dreams.recent.includes(:analysis)

    if @dreams.empty?
      redirect_to global_analyses_path, alert: 'Vous devez avoir enregistré au moins un rêve pour obtenir une analyse globale.'
      return
    end

    # Générer l'analyse globale
    interpreter = DreamInterpreterService.new(@dreams.first, current_user)
    interpretation = interpreter.interpret_global(@dreams)

    @global_analysis = current_user.global_analyses.create(interpretation: interpretation)

    if @global_analysis.persisted?
      redirect_to @global_analysis, notice: 'Analyse globale générée avec succès.'
    else
      redirect_to global_analyses_path, alert: 'Erreur lors de la génération de l\'analyse globale.'
    end
  end

  def destroy
    @global_analysis.destroy
    redirect_to global_analyses_path, notice: 'L\'analyse globale a été supprimée avec succès.'
  end

  private

  def set_global_analysis
    @global_analysis = current_user.global_analyses.find(params[:id])
  end
end
