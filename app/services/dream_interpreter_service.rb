class DreamInterpreterService
  include HTTParty

  def initialize(dream, user)
    @dream = dream
    @user = user
  end

  def interpret
    prompt = build_prompt
    response = call_ai_api(prompt)
    response
  end

  def interpret_global(dreams)
    prompt = build_global_prompt(dreams)
    response = call_ai_api_global(prompt)
    response
  end

  private

  def build_prompt
    user_info = if @user.quiz_completed?
      "Utilisateur: #{@user.first_name}, #{@user.age} ans, #{@user.gender}, signe astrologique: #{@user.zodiac_sign}, situation amoureuse: #{@user.relationship_status}"
    else
      "Utilisateur: Informations non disponibles"
    end

    <<~PROMPT
      Tu es un expert en interprétation des rêves avec une approche mystique et psychologique.

      #{user_info}

      Rêve à interpréter:
      Titre: #{@dream.title}
      Date: #{@dream.date}
      Contenu: #{@dream.content}

      Analyse ce rêve en profondeur en tenant compte:
      - Des symboles et archétypes présents
      - Du contexte personnel de l'utilisateur
      - Des significations psychologiques et mystiques
      - Des messages potentiels de l'inconscient

      Fournis une analyse détaillée, structurée et bienveillante en français.
      Sois précis et évite les généralités.
    PROMPT
  end

  def build_global_prompt(dreams)
    user_info = if @user.quiz_completed?
      "Utilisateur: #{@user.first_name}, #{@user.age} ans, #{@user.gender}, signe astrologique: #{@user.zodiac_sign}, situation amoureuse: #{@user.relationship_status}"
    else
      "Utilisateur: Informations non disponibles"
    end

    dreams_text = dreams.map do |dream|
      "Rêve du #{dream.date}: #{dream.title}\n#{dream.content}"
    end.join("\n\n---\n\n")

    <<~PROMPT
      Tu es un expert en interprétation des rêves avec une approche mystique et psychologique.

      #{user_info}

      Historique des rêves (#{dreams.count} rêves):
      #{dreams_text}

      Analyse l'ensemble de ces rêves pour identifier:
      - Les thèmes récurrents et patterns
      - L'évolution des symboles et archétypes
      - Les messages de l'inconscient sur une période
      - Les tendances psychologiques et spirituelles
      - Une synthèse globale de l'état intérieur

      Fournis une analyse globale détaillée, structurée et bienveillante en français.
      Sois précis et évite les généralités.
    PROMPT
  end

  def call_ai_api(prompt)
    # Utilisation d'OpenAI API (vous pouvez changer pour une autre API)
    # Pour utiliser cette fonctionnalité, vous devez avoir une clé API OpenAI
    # et la configurer dans les variables d'environnement

    api_key = ENV['OPENAI_API_KEY']

    if api_key.blank?
      # Fallback: retourne une analyse de démonstration
      return generate_demo_interpretation
    end

    begin
      response = HTTParty.post(
        'https://api.openai.com/v1/chat/completions',
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{api_key}"
        },
        body: {
          model: 'gpt-4',
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
          max_tokens: 2000
        }.to_json
      )

      if response.success?
        response.parsed_response['choices'][0]['message']['content']
      else
        Rails.logger.error("Erreur API OpenAI: #{response.code} - #{response.body}")
        generate_demo_interpretation
      end
    rescue => e
      Rails.logger.error("Erreur API IA: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n")) if Rails.env.development?
      generate_demo_interpretation
    end
  end

  def call_ai_api_global(prompt)
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
          model: 'gpt-4',
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

  def generate_demo_interpretation
    dream_title = @dream&.title || "votre rêve"
    <<~INTERPRETATION
      Analyse du rêve: #{dream_title}

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
