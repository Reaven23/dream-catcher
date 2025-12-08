class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :dreams, dependent: :destroy
  has_many :analyses, through: :dreams
  has_many :global_analyses, dependent: :destroy

  # Les colonnes JSONB PostgreSQL gèrent nativement la sérialisation

  # Options pour les champs du quiz
  GENRES = ["Femme", "Homme", "Non-binaire", "Autre", "Préfère ne pas répondre"].freeze
  SIGNES_ASTRO = ["Bélier", "Taureau", "Gémeaux", "Cancer", "Lion", "Vierge",
                  "Balance", "Scorpion", "Sagittaire", "Capricorne", "Verseau", "Poissons"].freeze
  RAPPEL_REVES = ["Presque jamais", "1-2 fois par mois", "1-2 fois par semaine", "Presque tous les jours"].freeze
  REVES_LUCIDES = ["Jamais", "Rarement", "Parfois", "Souvent"].freeze
  HUMEUR_OPTIONS = ["Positive", "Neutre", "Plutôt basse", "Très basse"].freeze
  SOURCES_STRESS = ["Travail / études", "Vie amoureuse", "Famille", "Finances", "Santé", "Autre"].freeze
  SITUATIONS_PRO = ["Étudiant·e", "Salarié·e", "Indépendant·e", "En recherche d'emploi", "Sans activité", "Autre"].freeze
  SITUATIONS_AFFECTIVES = ["Célibataire", "En couple", "Marié·e", "Séparé·e / divorcé·e", "Situation compliquée", "Préfère ne pas répondre"].freeze
  CHANGEMENTS_OPTIONS = ["Déménagement", "Séparation", "Nouvelle relation", "Changement travail/études", "Deuil", "Naissance/grossesse", "Autre"].freeze
  SYMBOLISME_OPTIONS = ["Plutôt rationnel", "Ouvert aux symboles", "Les deux"].freeze
  VISION_REVES_OPTIONS = ["Des choses bizarres du cerveau", "Une fenêtre sur l'inconscient", "Un mélange des deux", "Autre"].freeze
  TONS_PREFERES = ["Très soft / rassurant", "Plutôt nuancé", "Parfois direct (mais toujours bienveillant)"].freeze
  LONGUEURS_ANALYSE = ["Très courte", "Moyenne", "Détaillée"].freeze
  STYLES_ANALYSE = ["Scientifique / psycho", "Symbolique / imagé", "Coaching / conseils", "Mélange"].freeze

  def quiz_completed?
    # Rétrocompatible avec l'ancien système
    onboarding_completed? || (first_name.present? && zodiac_sign.present? && age.present?)
  end

  # Retourne le pourcentage de complétion du quiz
  def onboarding_progress
    fields = [:first_name, :age, :gender, :pays, :zodiac_sign, :rappel_reves,
              :reves_lucides, :heure_sommeil, :stress_niveau, :humeur_generale,
              :situation_pro, :relationship_status, :symbolisme, :vision_reves,
              :ton_prefere, :longueur_analyse, :style_prefere]

    completed = fields.count { |f| send(f).present? }
    (completed.to_f / fields.length * 100).round
  end
end
