class GlobalAnalysesController < ApplicationController
  def show
    @dreams = current_user.dreams.recent.includes(:analysis)

    if @dreams.empty?
      redirect_to dreams_path, alert: 'Vous devez avoir enregistré au moins un rêve pour obtenir une analyse globale.'
      return
    end

    # Générer l'analyse globale
    # On utilise le premier rêve comme référence pour initialiser le service
    interpreter = DreamInterpreterService.new(@dreams.first, current_user)
    @global_interpretation = interpreter.interpret_global(@dreams)
  end
end
