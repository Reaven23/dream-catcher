class DreamsController < ApplicationController
  before_action :set_dream, only: [:show]

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
      # Générer l'analyse avec l'IA
      interpreter = DreamInterpreterService.new(@dream, current_user)
      interpretation = interpreter.interpret

      @dream.create_analysis(interpretation: interpretation)

      redirect_to @dream, notice: 'Votre rêve a été enregistré et analysé avec succès.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_dream
    @dream = current_user.dreams.find(params[:id])
  end

  def dream_params
    params.require(:dream).permit(:title, :content, :date)
  end
end
