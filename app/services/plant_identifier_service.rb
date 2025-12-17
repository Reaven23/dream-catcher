class PlantIdentifierService
  def initialize(plant, user, image_path = nil)
    @plant = plant
    @user = user
    @image_path = image_path
  end

  # Retourne un hash d'attributs pour la plante
  # { name:, description:, sun_need:, water_need:, soil_need:, wind_need:, other_needs: }
  def identify
    # Mode démo global : on ne fait jamais d'appel API
    # return demo_attributes if ai_demo_mode?

    unless special_user?
      return demo_attributes
    end

    # On doit avoir un chemin de fichier image à envoyer à RubyLLM
    unless @image_path.present? && File.exist?(@image_path)
      Rails.logger.warn "[PlantIdentifierService] image_path manquant ou invalide, fallback démo"
      return demo_attributes
    end

    chat = RubyLLM.chat(model: "gpt-4o")
    response = chat.ask(prompt, with: { image: @image_path })
    Rails.logger.info "[PlantIdentifierService] raw response.content=#{response.content.inspect}"

    # L'IA répond avec un bloc ```json ... ```, on nettoie avant de parser
    raw = response.content.to_s
    cleaned = raw.sub(/\A```json\s*/i, "").sub(/\A```\s*/i, "").sub(/```[\s\n]*\z/, "")
    Rails.logger.info "[PlantIdentifierService] cleaned JSON=#{cleaned.inspect}"

    parsed = JSON.parse(cleaned) rescue {}

    build_attributes_from(parsed)
  rescue => e
    Rails.logger.error("Erreur PlantIdentifierService: #{e.class} - #{e.message}")
    demo_attributes
  end

  private

  def prompt
    <<~PROMPT
      Tu es un expert en plante et reconnait immédiattement les plantes avec une image et leur besoin. Tu reçois une photo d'une plante.

      Objectif:
      - Identifier la plante de la manière la plus précise possible (espèce ou au moins type).
      - Décrire brièvement la plante (aspect, particularités).
      - Fournir ses besoins principaux (soleil, eau, type de sol, exposition au vent, autres conseils).

      Tu dois répondre STRICTEMENT avec un JSON valide (sans texte autour), au format:
      {
        "name": "Nom le plus probable de la plante",
        "description": "Courte description en français (2-4 phrases).",
        "needs": {
          "sun": "Besoins en lumière (par ex: plein soleil, mi-ombre...).",
          "water": "Besoins en eau (fréquence, quantité...).",
          "soil": "Type de sol idéal (drainant, riche, acide, etc.).",
          "wind": "Sensibilité au vent / exposition recommandée.",
          "other": "Autres conseils d'entretien utiles généraux mais aussi spécifique à la photo que tu as vu"
        }
      }

      Réponds uniquement avec cet objet JSON.
    PROMPT
  end

  # Mode démo forcé pour les tests : toujours true
  # Pour remettre l'IA réelle, soit :
  # - remplace par une lecture d'ENV, soit
  # - supprime l'appel à ai_demo_mode? dans identify
  def ai_demo_mode?
    true
  end

  def special_user?
    special_email = ENV["SPECIAL_USER_EMAIL"]
    @user&.email.present? && special_email.present? && @user.email == special_email
  end

  def build_attributes_from(json)
    needs = json["needs"] || {}

    {
      name: json["name"].presence || "Plante mystère",
      description: json["description"],
      sun_need: needs["sun"],
      water_need: needs["water"],
      soil_need: needs["soil"],
      wind_need: needs["wind"],
      other_needs: needs["other"]
    }
  end

  def demo_attributes
    {
      name: "Plante mystère",
      description: "Une belle plante verte non identifiée. Ajoutez une description personnalisée quand vous connaîtrez son nom.",
      sun_need: "Lumière indirecte ou mi-ombre.",
      water_need: "Arrosage modéré, laisser sécher légèrement la surface du sol entre deux arrosages.",
      soil_need: "Sol bien drainé, mélange terreau universel + perlite ou sable.",
      wind_need: "Éviter les courants d'air froid et le vent direct.",
      other_needs: "Surveillez l'état des feuilles (couleur, taches) pour ajuster l'arrosage et la lumière."
    }
  end
end
