class DreamInterpreterService
  include HTTParty

  def initialize(dream, user)
    @dream = dream
    @user = user
  end

  def interpret
    prompt = build_prompt
    response = call_ai_api(prompt)
    parse_response(response)
  end

  def interpret_global(dreams)
    prompt = build_global_prompt(dreams)
    response = call_ai_api_global(prompt)
    response
  end

  private

  def build_prompt
    user_profile = build_user_profile
    style_instructions = build_style_instructions

    <<~PROMPT
      Tu es un expert en interprétation des rêves avec une approche mystique et psychologique.

      #{user_profile}

      Rêve à interpréter:
      Date: #{@dream.date}
      Contenu: #{@dream.content}

      #{style_instructions}

      Analyse ce rêve en profondeur en tenant compte:
      - Des symboles et archétypes présents
      - Du contexte personnel et émotionnel de l'utilisateur
      - De son rapport au symbolisme et à l'inconscient
      - Des significations psychologiques et mystiques
      - Des messages potentiels de l'inconscient
      - De ses peurs et émotions récurrentes si pertinent

      IMPORTANT: Tu dois répondre UNIQUEMENT avec un objet JSON valide (sans backticks ```) au format suivant:
      {
        "titre": "Un titre court et descriptif basé sur le contenu du rêve",
        "analyse": "Ton analyse en Markdown structuré ici..."
      }

      Le titre doit être:
      - Court (3-6 mots maximum)
      - Directement lié au contenu concret du rêve (lieux, personnages, actions, objets mentionnés)
      - Descriptif et évocateur du rêve spécifique (pas générique)
      - Exemples: "Poursuite dans le métro", "Le chien qui parlait", "Vol au-dessus des montagnes"
      - En français

      L'analyse DOIT être formatée en Markdown avec cette structure:

      ## 🔮 Résumé
      Un court paragraphe résumant l'essence du rêve et son message principal.

      ## 🎭 Symboles clés
      - **Symbole 1** : explication
      - **Symbole 2** : explication
      - etc.

      ## 🧠 Analyse psychologique
      Interprétation du point de vue psychologique (Jung, inconscient, etc.)

      ## ✨ Dimension symbolique/mystique
      Interprétation symbolique ou spirituelle si pertinent.

      ## 💡 Message pour toi
      Ce que ton inconscient essaie peut-être de te dire, avec un ton personnel et bienveillant.

      ## 🌱 Pistes de réflexion
      - Question ou suggestion 1
      - Question ou suggestion 2

      Utilise des **mots en gras** pour les concepts importants et des *italiques* pour les nuances.
    PROMPT
  end

  def build_global_prompt(dreams)
    user_profile = build_user_profile
    style_instructions = build_style_instructions

    dreams_text = dreams.map do |dream|
      "Rêve du #{dream.date}: #{dream.title}\n#{dream.content}"
    end.join("\n\n---\n\n")

    <<~PROMPT
      Tu es un expert en interprétation des rêves avec une approche mystique et psychologique.

      #{user_profile}

      Historique des rêves (#{dreams.count} rêves):
      #{dreams_text}

      #{style_instructions}

      Analyse l'ensemble de ces rêves et structure ta réponse en Markdown:

      ## 🌙 Vue d'ensemble
      Synthèse générale de l'ensemble des rêves et de leur cohérence.

      ## 🔄 Thèmes récurrents
      - **Thème 1** : description et signification
      - **Thème 2** : description et signification
      - etc.

      ## 🎭 Symboles dominants
      Les symboles qui reviennent le plus souvent et leur évolution.

      ## 📈 Évolution dans le temps
      Comment les rêves ont évolué, ce que cela peut signifier.

      ## 🧠 Analyse psychologique globale
      Ce que l'ensemble révèle sur l'état intérieur.

      ## 💡 Messages de l'inconscient
      Les messages importants qui émergent de cette période.

      ## 🌱 Recommandations
      - Suggestion 1
      - Suggestion 2
      - etc.

      Utilise des **mots en gras** pour les concepts importants et sois bienveillant.
    PROMPT
  end

  def build_user_profile
    return "Profil utilisateur: Informations non disponibles" unless @user.quiz_completed?

    profile_parts = []

    # Informations de base
    profile_parts << "Prénom: #{@user.first_name}" if @user.first_name.present?
    profile_parts << "Âge: #{@user.age} ans" if @user.age.present?
    profile_parts << "Genre: #{@user.gender}" if @user.gender.present?
    profile_parts << "Pays: #{@user.pays}" if @user.pays.present?
    profile_parts << "Signe astrologique: #{@user.zodiac_sign}" if @user.zodiac_sign.present?

    # Contexte de vie
    profile_parts << "Situation professionnelle: #{@user.situation_pro}" if @user.situation_pro.present?
    profile_parts << "Situation affective: #{@user.relationship_status}" if @user.relationship_status.present?

    if @user.changements_recents.present? && @user.changements_recents.any?
      profile_parts << "Changements récents: #{@user.changements_recents.join(', ')}"
    end

    # Contexte émotionnel
    profile_parts << "Niveau de stress actuel: #{@user.stress_niveau}/10" if @user.stress_niveau.present?
    profile_parts << "Humeur générale: #{@user.humeur_generale}" if @user.humeur_generale.present?

    if @user.source_stress.present? && @user.source_stress.any?
      profile_parts << "Sources de stress: #{@user.source_stress.join(', ')}"
    end

    # Rapport aux rêves
    profile_parts << "Fréquence de rappel des rêves: #{@user.rappel_reves}" if @user.rappel_reves.present?
    profile_parts << "Rêves lucides: #{@user.reves_lucides}" if @user.reves_lucides.present?
    profile_parts << "Heure de coucher: #{@user.heure_sommeil}" if @user.heure_sommeil.present?
    profile_parts << "Rapport au symbolisme: #{@user.symbolisme}" if @user.symbolisme.present?
    profile_parts << "Vision des rêves: #{@user.vision_reves}" if @user.vision_reves.present?

    # Peurs et émotions
    profile_parts << "Peurs principales: #{@user.peurs_principales}" if @user.peurs_principales.present?
    profile_parts << "Émotions récurrentes dans les rêves: #{@user.emotions_recurrentes}" if @user.emotions_recurrentes.present?

    <<~PROFILE
      === PROFIL DE L'UTILISATEUR ===
      #{profile_parts.join("\n")}
    PROFILE
  end

  def build_style_instructions
    instructions = []

    # Ton de l'analyse
    case @user.ton_prefere
    when "Très soft / rassurant"
      instructions << "Adopte un ton très doux, rassurant et bienveillant. Évite tout ce qui pourrait inquiéter."
    when "Plutôt nuancé"
      instructions << "Adopte un ton équilibré et nuancé, à la fois bienveillant et honnête."
    when "Parfois direct (mais toujours bienveillant)"
      instructions << "Tu peux être direct et franc dans ton analyse, tout en restant bienveillant."
    end

    # Longueur de l'analyse
    case @user.longueur_analyse
    when "Très courte"
      instructions << "Fournis une analyse concise et synthétique (environ 150-200 mots)."
    when "Moyenne"
      instructions << "Fournis une analyse de longueur moyenne (environ 300-400 mots)."
    when "Détaillée"
      instructions << "Fournis une analyse détaillée et approfondie (environ 500-700 mots)."
    end

    # Style d'analyse
    case @user.style_prefere
    when "Scientifique / psycho"
      instructions << "Privilégie une approche psychologique et scientifique (références à Jung, Freud, neurosciences du rêve)."
    when "Symbolique / imagé"
      instructions << "Privilégie une approche symbolique, mystique et imagée (archétypes, symboles universels, mythologie)."
    when "Coaching / conseils"
      instructions << "Privilégie une approche orientée coaching avec des conseils pratiques et des pistes de réflexion."
    when "Mélange"
      instructions << "Mélange les approches psychologique, symbolique et coaching de manière équilibrée."
    end

    return "" if instructions.empty?

    <<~STYLE
      === INSTRUCTIONS DE STYLE ===
      #{instructions.join("\n")}
    STYLE
  end

  def call_ai_api(prompt)
    # Mode démo global (désactive tous les appels API IA)
    # return generate_demo_response if ai_demo_mode?

    # En mode normal, accès IA pour special user (ENV) ou rôle premium
    return generate_demo_response unless can_use_dream_ia?

    api_key = ENV['OPENAI_API_KEY']

    if api_key.blank?
      return generate_demo_response
    end

    begin
      response = HTTParty.post(
        'https://api.openai.com/v1/chat/completions',
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{api_key}"
        },
        body: {
          model: 'gpt-4o',
          messages: [
            {
              role: 'system',
              content: 'Tu es un expert en interprétation des rêves. Tu réponds TOUJOURS en JSON valide sans markdown ni backticks.'
            },
            {
              role: 'user',
              content: prompt
            }
          ],
          temperature: 0.7,
          max_tokens: 2000,
          response_format: { type: "json_object" }
        }.to_json
      )

      if response.success?
        response.parsed_response['choices'][0]['message']['content']
      else
        Rails.logger.error("Erreur API OpenAI: #{response.code} - #{response.body}")
        generate_demo_response
      end
    rescue => e
      Rails.logger.error("Erreur API IA: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n")) if Rails.env.development?
      generate_demo_response
    end
  end

  def parse_response(response)
    begin
      json = JSON.parse(response)
      {
        title: json['titre'] || json['title'],
        analysis: json['analyse'] || json['analysis']
      }
    rescue JSON::ParserError => e
      Rails.logger.error("Erreur parsing JSON: #{e.message}")
      Rails.logger.error("Response: #{response}")
      # Fallback: utiliser la réponse brute comme analyse
      {
        title: nil,
        analysis: response
      }
    end
  end

  def generate_demo_response
    # Essayer d'extraire un titre du contenu du rêve
    content_words = @dream.content.to_s.split.first(5).join(" ")
    title = content_words.present? ? "Rêve: #{content_words}..." : "Rêve du #{@dream.date}"

    {
      "titre" => title,
      "analyse" => generate_demo_interpretation_text
    }.to_json
  end

  def call_ai_api_global(prompt)
    # return generate_demo_global_interpretation if ai_demo_mode?

    return generate_demo_global_interpretation unless can_use_dream_ia?

    api_key = ENV['OPENAI_API_KEY']

    if api_key.blank?
      return generate_demo_global_interpretation
    end

    begin
      response = HTTParty.post(
        'https://api.openai.com/v1/chat/completions',
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{api_key}"
        },
        body: {
          model: 'gpt-4o',
          messages: [
            {
              role: 'system',
              content: 'Tu es un expert en interprétation des rêves avec une approche mystique et psychologique.'
            },
            {
              role: 'user',
              content: prompt
            }
          ],
          temperature: 0.7,
          max_tokens: 3000
        }.to_json
      )

      if response.success?
        response.parsed_response['choices'][0]['message']['content']
      else
        generate_demo_global_interpretation
      end
    rescue => e
      Rails.logger.error("Erreur API IA: #{e.message}")
      generate_demo_global_interpretation
    end
  end

  def can_use_dream_ia?
    special_user? || @user&.role == 'premium'
  end

  def special_user?
    special_email = ENV['SPECIAL_USER_EMAIL']
    @user&.email.present? && special_email.present? && @user.email == special_email
  end

  def ai_demo_mode?
    true
  end

  def generate_demo_interpretation_text
    <<~INTERPRETATION
      Ce rêve révèle des aspects profonds de votre inconscient. Les symboles présents dans votre récit onirique suggèrent des messages importants de votre psyché.

      Les éléments clés à retenir:
      - Les symboles présents dans votre rêve ont une signification personnelle liée à votre parcours
      - Votre inconscient communique à travers ces images
      - Il est important de noter les émotions ressenties pendant le rêve

      Pour une analyse plus approfondie, consultez un spécialiste en interprétation des rêves.

      Note: Cette analyse est générée automatiquement. Pour activer l'analyse par IA, configurez votre clé API OpenAI dans les variables d'environnement.
    INTERPRETATION
  end

  def generate_demo_global_interpretation
    <<~INTERPRETATION
      Analyse Globale de vos Rêves

      En examinant l'ensemble de vos rêves, plusieurs patterns émergent qui révèlent des aspects profonds de votre inconscient.

      Thèmes récurrents identifiés:
      - Les symboles présents dans vos rêves suggèrent des messages importants de votre psyché
      - Votre inconscient communique à travers ces images répétitives
      - Il est important de noter l'évolution des thèmes au fil du temps

      Tendances observées:
      - Les émotions et situations récurrentes dans vos rêves
      - Les archétypes qui apparaissent régulièrement
      - Les messages de votre inconscient sur une période

      Pour une analyse plus approfondie, consultez un spécialiste en interprétation des rêves.

      Note: Cette analyse est générée automatiquement. Pour activer l'analyse par IA, configurez votre clé API OpenAI dans les variables d'environnement.
    INTERPRETATION
  end
end
