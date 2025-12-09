class GlobalAnalysesController < ApplicationController
  before_action :set_global_analysis, only: [:show, :destroy]

  DREAM_COUNT_OPTIONS = [2, 5, 10, 20].freeze

  def index
    @global_analyses = current_user.global_analyses.recent
    @dreams = current_user.dreams.recent.includes(:analysis)
    @dreams_count = @dreams.count
    @available_options = DREAM_COUNT_OPTIONS.select { |n| @dreams_count >= n }
    @can_generate = @available_options.any?
  end

  def show
  end

  def create
    dreams_limit = params[:dreams_count].to_i
    dreams_limit = DREAM_COUNT_OPTIONS.include?(dreams_limit) ? dreams_limit : DREAM_COUNT_OPTIONS.first

    @dreams = current_user.dreams.recent.includes(:analysis).limit(dreams_limit)

    if @dreams.empty?
      redirect_to global_analyses_path, alert: 'Vous devez avoir enregistré au moins 2 rêves pour obtenir une analyse globale.'
      return
    end

    # Générer l'analyse globale
    interpreter = DreamInterpreterService.new(@dreams.first, current_user)
    interpretation = interpreter.interpret_global(@dreams)

    # Récupérer les dates du premier et dernier rêve
    dream_dates = @dreams.map(&:date).compact
    first_date = dream_dates.min
    last_date = dream_dates.max

    @global_analysis = current_user.global_analyses.create(
      interpretation: interpretation,
      dreams_count: @dreams.count,
      first_dream_date: first_date,
      last_dream_date: last_date
    )

    if @global_analysis.persisted?
      redirect_to @global_analysis, notice: "Analyse globale de vos #{@dreams.count} derniers rêves générée avec succès."
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
